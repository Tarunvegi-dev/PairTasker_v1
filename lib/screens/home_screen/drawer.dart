import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../helpers/methods.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

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
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjdKRG2b-Z-wzIFPlATwulI-kKBy9LiKNcpAdBG4u5mf2X3aVPp2p62JYts9jz-1ABOnI&usqp=CAU'),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Will Smith',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '@willsmith143',
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
                    Container(
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
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
                            'assets/images/icons/drawer/tasker_mode.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Tasker Mode',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
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
                            'assets/images/icons/drawer/terms-and-conditions.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Terms & Conditions',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
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
                    Container(
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
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
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
