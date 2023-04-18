import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';

class OfflineScreen extends StatelessWidget {
  final refreshScreen;
  const OfflineScreen({this.refreshScreen, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/icons/no_internet.png',
                    width: 230,
                    height: 230,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'You are currently offline, please connect to internet and try again!',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: HexColor('FF033E')),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Helper.isDark(context) ? Colors.black : Colors.white,
                    ),
                    onPressed: refreshScreen,
                    icon: Icon(
                      Icons.refresh,
                      color: HexColor('007FFF'),
                    ),
                    label: Text(
                      'Refresh',
                      style: GoogleFonts.poppins(
                          color: HexColor('007FFF'),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
