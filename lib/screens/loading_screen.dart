import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var newMode;
  String gender = 'male';
  double userModeHeight = 0;
  double taskerModeHeight = 0;

  @override
  void didChangeDependencies() async {
    final mode =
        Provider.of<Auth>(context, listen: false).isTasker ? 'User' : 'Tasker';
    final prefs = await SharedPreferences.getInstance();
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    setState(() {
      gender = userdata['gender'];
      newMode = mode;
      userModeHeight = mode == 'Tasker' ? 300.0 : 0;
      taskerModeHeight = mode == 'User' ? 300.0 : 0;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        userModeHeight = mode == 'Tasker' ? 0 : 300.0;
        taskerModeHeight = mode == 'User' ? 0 : 300.0;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  height: userModeHeight,
                  child: Image.asset(
                    'assets/images/icons/user_$gender.png',
                    width: 230,
                    height: 230,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  height: taskerModeHeight,
                  child: Image.asset(
                    'assets/images/icons/Tasker.png',
                    width: 230,
                    height: 230,
                  ),
                ),
                Text(
                  'Switching to $newMode Mode',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
