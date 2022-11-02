import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/screens/home_screen/taskers_list.dart';
import 'recents.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(
                          right: 12,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(125),
                          ),
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/images/icons/menu.svg',
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: HexColor('#007FFF'),
                            size: 20,
                          ),
                          Text(
                            'Guntur, AP',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(125),
                        ),
                        color: HexColor('007FFF'),
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 81 / 100,
              decoration: BoxDecoration(
                color: HexColor('#E4ECF5'),
              ),
              child: ListView(
                children: const [
                  Recents(),
                  TaskersList(),
                ],
              ),
            )
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
              SvgPicture.asset("assets/images/icons/navbar/home.svg"),
              InkWell(
                onTap: () => {Navigator.pushReplacementNamed(context, '/wishlist')},
                child:
                    SvgPicture.asset("assets/images/icons/navbar/wishlist.svg"),
              ),
              SvgPicture.asset(
                "assets/images/icons/navbar/my_requests.svg",
              ),
              InkWell(
                onTap: () => {Navigator.pushReplacementNamed(context, '/notifications')},
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
