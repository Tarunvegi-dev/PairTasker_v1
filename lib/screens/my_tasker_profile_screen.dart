import 'package:flutter/material.dart';
import 'package:pairtasker/providers/auth.dart';
import '../helpers/methods.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/screens/screens.dart';
import 'package:pairtasker/theme/widgets.dart';

class MyTaskerProfile extends StatefulWidget {
  const MyTaskerProfile({super.key});

  @override
  State<MyTaskerProfile> createState() => _MyTaskerProfileState();
}

class _MyTaskerProfileState extends State<MyTaskerProfile> {
  bool taskerMode = false;
  List<dynamic> workingCategories = [];

  bool isLoading = false;
  var _isinit = true;
  bool _isEditing = false;
  var bio = TextEditingController();
  var error = '';

  @override
  void didChangeDependencies() async {
    if (_isinit) {
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      if (userdata['isTasker'] != null && userdata['isTasker'] != false) {
        setState(() {
          taskerMode = userdata['tasker']['isOnline'];
          workingCategories = userdata['tasker']['workingCategories'];
          bio = TextEditingController(text: userdata['tasker']['bio'] ?? '');
        });
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  Future<void> updateTaskerStatus(bool status) async {
    setState(() {
      taskerMode = status;
    });
    final response = await Provider.of<Tasker>(context, listen: false)
        .setTaskerOnline(status);
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // ignore: use_build_context_synchronously
          backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
          content: Text(
            response.data['message'],
            style: GoogleFonts.poppins(
              // ignore: use_build_context_synchronously
              color: Helper.isDark(context) ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }
  }

  Future<void> updateTaskerBio() async {
    setState(() {
      error = '';
      isLoading = true;
    });
    Map<String, dynamic> taskerdata = {
      "bio": bio.text,
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
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 8 / 100,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Helper.isDark(context) ? Colors.white : Colors.black,
                    width: 0.2,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: HexColor('99A4AE'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'My Tasker Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(
                      readOnly: !_isEditing,
                      maxLines: 3,
                      controller: bio,
                      decoration: InputDecoration(
                        hintText: 'Describe yourself',
                        hintStyle: GoogleFonts.lato(
                          fontSize: 12,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor(
                              '99A4AE',
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (error != '')
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ErrorMessage(error)
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor('007FFF'),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tasker Mode',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Switch(
                                value: taskerMode,
                                activeColor: Colors.white,
                                onChanged: (value) => updateTaskerStatus(value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: HexColor('99A4AE'),
                            width: 0.5,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        bottom: 18,
                        left: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Working Categories',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => TaskerDetails(
                                      workingCategories: workingCategories,
                                      isUpdating: true,
                                    )),
                              ),
                            ),
                            child: Text(
                              'manage',
                              style: GoogleFonts.lato(
                                color: HexColor('007FFF'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: workingCategories.length,
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 15,
                          right: 5,
                          bottom: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${'${workingCategories[index][0]}'.toUpperCase()}${workingCategories[index].toString().substring(1).toLowerCase()}',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('007FFF'),
                                  width: 2.3,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: Container(
                                  height: 6,
                                  width: 6,
                                  color: HexColor('007FFF'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Delete tasker account',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: HexColor('FF033E'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                  backgroundColor: _isEditing
                      ? HexColor('007FFF')
                      : Helper.isDark(context)
                          ? HexColor('252B30')
                          : HexColor('DEE0E0'),
                  elevation: 0,
                ),
                onPressed: isLoading
                    ? null
                    : _isEditing
                        ? updateTaskerBio
                        : () => setState(() {
                              _isEditing = true;
                            }),
                child: isLoading
                    ? const LoadingSpinner()
                    : Text(
                        _isEditing ? 'Save' : 'Edit',
                        style: GoogleFonts.lato(
                          color: _isEditing ? Colors.white : HexColor('007FFF'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
