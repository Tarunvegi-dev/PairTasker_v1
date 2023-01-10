import 'package:flutter/material.dart';
import '../helpers/methods.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/screens/screens.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Icon(
                    Icons.more_vert,
                    size: 28,
                    color: HexColor('99A4AE'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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
            )
          ],
        ),
      ),
    );
  }
}
