// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/screens/select_community/community_widget.dart';
import 'package:pairtasker/screens/select_community/select_community_screen.dart';
import 'package:pairtasker/theme/theme.dart';
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
  List<dynamic> communities = [];

  bool isLoading = false;
  var _isinit = true;
  bool _isEditing = false;
  var bio = TextEditingController();
  var error = '';

  @override
  void didChangeDependencies() async {
    if (_isinit) {
      fetchTaskerProfile();
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  void fetchTaskerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    List<dynamic> communitiesData = userdata['tasker']['communities'];
    if (communitiesData.isEmpty) {
      final responseData =
          await Provider.of<Tasker>(context, listen: false).getMyCommunities();
      communitiesData = responseData;
    }
    if (userdata['isTasker'] != null) {
      setState(() {
        communities = communitiesData;
        taskerMode = userdata['tasker']['isOnline'];
        workingCategories = userdata['tasker']['workingCategories'];
        bio = TextEditingController(text: userdata['tasker']['bio'] ?? '');
      });
    }
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
          duration: const Duration(
            seconds: 2,
          ),
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
                  InkWell(
                    onTap: _isEditing
                        ? updateTaskerBio
                        : () => setState(() {
                              _isEditing = true;
                            }),
                    child: isLoading
                        ? const LoadingSpinner()
                        : _isEditing
                            ? Icon(
                                Icons.done,
                                size: 28,
                                color: HexColor('007FFF'),
                              )
                            : Helper.isDark(context)
                                ? Image.asset(
                                    'assets/images/icons/edit_light.png',
                                    height: 20,
                                  )
                                : Image.asset(
                                    'assets/images/icons/edit.png',
                                    height: 20,
                                  ),
                  )
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
                            ).then((value) {
                              fetchTaskerProfile();
                            }),
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
                              '${workingCategories[index]}',
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
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: HexColor('99A4AE'),
                            width: 0.5,
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      padding: const EdgeInsets.only(
                        bottom: 18,
                        left: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: HexColor('AAABAB'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Communities',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => SelectCommunityScreen(
                                      isUpdating: true,
                                      selectedCommunities: communities
                                          .map((community) => community['id'])
                                          .toList()
                                          .join(' '),
                                    )),
                              ),
                            ).then((value) {
                              fetchTaskerProfile();
                            }),
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
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      itemCount: communities.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) => ApartmentWidget(
                          isSelected: false,
                          name: communities[i]['name'],
                          imageUrl: communities[i]['picture'],
                          address: communities[i]['address']['line'],
                          city:
                              '${communities[i]['address']['city']}, ${communities[i]['address']['state']}, ${communities[i]['address']['pincode']}'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const TaskerBottomNavBarWidget(3),
    );
  }
}
