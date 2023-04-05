import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/screens/select_community/select_community_screen.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import 'package:dio/dio.dart';

class TaskerDetails extends StatefulWidget {
  final List<dynamic> workingCategories;
  final bool isUpdating;

  const TaskerDetails(
      {required this.workingCategories, required this.isUpdating, super.key});

  @override
  State<TaskerDetails> createState() => _TaskerDetailsState();
}

class _TaskerDetailsState extends State<TaskerDetails> {
  final List<String> kOptions = [];

  List<dynamic> _workingCategories = <String>[];
  final category = TextEditingController();
  bool isLoading = false;
  var error = '';

  @override
  void initState() {
    if (widget.isUpdating) {
      setState(() {
        _workingCategories = widget.workingCategories;
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final response = await Provider.of<Auth>(context, listen: false)
        .fetchWorkingCategories();
    final workingCategories = response.data['data'] as List<dynamic>;
    if (response.statusCode == 200) {
      for (var w in workingCategories) {
        setState(() {
          kOptions.add(w['name']);
        });
      }
    }
    super.didChangeDependencies();
  }

  Future<void> createTasker() async {
    setState(() {
      error = '';
      isLoading = true;
    });
    final response = await Provider.of<Auth>(context, listen: false)
        .createTasker(_workingCategories);
    if (response.statusCode != 200) {
      setState(() {
        error = response.data['message'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const SelectCommunityScreen()),
        ),
      );
    }
  }

  Future<void> updateTasker() async {
    setState(() {
      error = '';
      isLoading = true;
    });
    Map<String, dynamic> taskerdata = {
      'workingCategories': _workingCategories,
    };
    final response = await Provider.of<Auth>(context, listen: false)
        .updateTasker(taskerdata);
    if (response.statusCode != 200) {
      setState(() {
        error = response.data['message'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 75, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Working Categories',
                    style: PairTaskerTheme.title3,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: kOptions.length,
                    itemBuilder: (context, i) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_workingCategories.contains(kOptions[i])) {
                            _workingCategories.remove(kOptions[i]);
                          } else {
                            _workingCategories.add(kOptions[i]);
                          }
                        });
                      },
                      child: Container(
                        width: 335,
                        height: 46,
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor('007FFF'),
                          ),
                          color: _workingCategories.contains(kOptions[i])
                              ? HexColor('007FFF')
                              : Helper.isDark(context)
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                kOptions[i]
                                        .toString()
                                        .characters
                                        .first
                                        .toUpperCase() +
                                    kOptions[i].toString().substring(1),
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_workingCategories.contains(kOptions[i]))
                                const Icon(Icons.done)
                              else
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _workingCategories.add(kOptions[i]);
                                      });
                                    },
                                    child: const Icon(Icons.add))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                        backgroundColor: HexColor('007FFF'),
                        elevation: 0,
                      ),
                      onPressed: isLoading || _workingCategories.isEmpty
                          ? null
                          : widget.isUpdating
                              ? updateTasker
                              : createTasker,
                      child: isLoading
                          ? const LoadingSpinner()
                          : Text(
                              'Save',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
