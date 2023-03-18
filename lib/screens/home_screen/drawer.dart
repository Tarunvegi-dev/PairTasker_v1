import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helpers/methods.dart';
import '../../providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  var username = '';
  var displayName = '';
  var profilePicture = '';
  bool isTasker = false;
  var _isinit = true;

  @override
  void didChangeDependencies() async {
    if (_isinit) {
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      setState(() {
        username = userdata['username'] ?? '';
        displayName = userdata['displayName'] ?? '';
        profilePicture = userdata['profilePicture'] ?? '';
        isTasker = Provider.of<Auth>(context, listen: false).isTasker;
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  void switchMode() {
    Navigator.of(context).pushNamed('/loading');
    Future.delayed(const Duration(seconds: 5), () async {
      final response =
          await Provider.of<Auth>(context, listen: false).updateIsTasker();
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_conteFxt_synchronously, use_build_context_synchronously
        Navigator.of(context).pushNamed('/');
      } else {
        if (response.data['hasAccount'] == false) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: HexColor('FF033E'),
            content: Text(
              'You are currently not a tasker, please create a tasker account to continue',
              style: GoogleFonts.poppins(
                // ignore: use_build_context_synchronously
                color: Helper.isDark(context) ? Colors.white : Colors.black,
              ),
            ),
          ));
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushNamed('/taskerform');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                margin: const EdgeInsets.only(
                  top: 40,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Scaffold.of(context).closeDrawer(),
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: HexColor('99A4AE'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundImage: profilePicture != ''
                              ? NetworkImage(profilePicture)
                              : const AssetImage(
                                  'assets/images/default_user.png',
                                ) as ImageProvider,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        displayName,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '@$username',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: HexColor('AAABAB'),
                        ),
                      ),
                    ]),
              ),
              Container(
                color: Helper.isDark(context)
                    ? HexColor('252B30')
                    : HexColor('E4ECF5'),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/myprofile'),
                      child: Container(
                        color: Helper.isDark(context)
                            ? Colors.black
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 27,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 5,
                          top: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/icons/drawer/profile.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              'View Profile',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: switchMode,
                      child: Container(
                        color: Helper.isDark(context)
                            ? Colors.black
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 27,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/icons/drawer/switch.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Switch to ${isTasker ? 'User' : 'Tasker'}',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        '/privacy-policy',
                      ),
                      child: Container(
                        color: Helper.isDark(context)
                            ? Colors.black
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 23,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/icons/drawer/privacy-policy.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Privacy Policy',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        '/faq',
                      ),
                      child: Container(
                        color: Helper.isDark(context)
                            ? Colors.black
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 23,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/icons/drawer/faq.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "FAQ's",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final uri = Uri.parse('https://pairtaskerapp.web.app/');
                        launchUrl(uri);
                      },
                      child: Container(
                        color: Helper.isDark(context)
                            ? Colors.black
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 23,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/icons/drawer/share.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Share the app',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor('FF033E'),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
              ),
              child: const Text('Logout'),
              onPressed: () =>
                  Provider.of<Auth>(context, listen: false).logout(context),
            ),
          )
        ],
      ),
    );
  }
}
