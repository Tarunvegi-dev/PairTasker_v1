import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/screens/home_screen/taskers_list.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 8 / 100,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 0.2,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Text(
                'Wishlist',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 80 / 100,
              decoration: BoxDecoration(
                color: HexColor('#E4ECF5'),
              ),
              child: ListView(
                children: const [TaskersList()],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 7 / 100,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => {Navigator.pushReplacementNamed(context, '/home')},
                child: SvgPicture.asset("assets/images/icons/navbar/home.svg"),
              ),
              SvgPicture.asset("assets/images/icons/navbar/wishlist.svg"),
              SvgPicture.asset("assets/images/icons/navbar/my_requests.svg"),
              InkWell(
                onTap: () => {Navigator.pushNamed(context, '/notifications')},
                child: SvgPicture.asset(
                  "assets/images/icons/navbar/notifications.svg",
                ),
              ),
              SvgPicture.asset("assets/images/icons/navbar/my_tasks.svg"),
            ],
          ),
        ),
      ),
    );
  }
}
