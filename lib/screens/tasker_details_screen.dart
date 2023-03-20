import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/providers/auth.dart';
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
  final List<String> kOptions = <String>[
    'delivery boy',
    'photographer',
  ];

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
      Navigator.of(context).pushReplacementNamed('/');
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
                  Autocomplete<String>(
                    fieldViewBuilder: (
                      context,
                      category,
                      focusNode,
                      onFieldSubmitted,
                    ) =>
                        TextFormField(
                      controller: category,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'search category..',
                        hintStyle: GoogleFonts.lato(
                          fontSize: 14,
                          color: HexColor('6F7273'),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: HexColor('AAABAB'),
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 50,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: HexColor('AAABAB'),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    optionsViewBuilder: (context, onSelected, options) => Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        child: SizedBox(
                          width: 370,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(1.0),
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final option = options.elementAt(index);
                              return GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: ListTile(
                                  title: Text(
                                    option,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return kOptions.where((String option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      setState(() {
                        if (!_workingCategories.contains(selection)) {
                          _workingCategories.add(selection);
                        }
                      });
                      category.clear();
                    },
                  ),
                  SizedBox(
                    height: error != '' ? 20 : 35,
                  ),
                  if (error != '')
                    Column(
                      children: [
                        ErrorMessage(error),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  Text(
                    'Working Categories',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HexColor('6F7273')),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Wrap(
                    spacing: 5.0,
                    runSpacing: 15.0,
                    children: _workingCategories
                        .map(
                          (category) => Container(
                            width: 100,
                            height: 24,
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor('007FFF'),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => setState(() {
                                      _workingCategories.remove(category);
                                    }),
                                    child: Image.asset(
                                      "assets/images/icons/close.png",
                                      height: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
