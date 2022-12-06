import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../screens/screens.dart';
import '../helpers/methods.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBarWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectedScreen;
  final List<Widget> screens = const [
    HomePage(),
    WishlistScreen(),
    MyRequests(),
    NotificationScreen(),
    MyTasks(),
  ];

  const BottomNavBarWidget(this.selectedScreen, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Helper.isDark(context) ? Colors.white : Colors.black,
            width: 0.2,
          ),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 7 / 100,
        width: MediaQuery.of(context).size.width,
        child: BottomNavigationBar(
          currentIndex: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            if (value != selectedScreen) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      screens[value],
                  transitionDuration: Duration.zero,
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/home.svg",
                width: 25,
                color: selectedScreen == 0
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/wishlist.svg",
                width: 23,
                color: selectedScreen == 1
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/my_requests.svg",
                width: 25,
                color: selectedScreen == 2
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: 'MyRequests',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/notifications.svg",
                width: 25,
                color: selectedScreen == 3
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: "notifications",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/my_tasks.svg",
                width: 25,
                color: selectedScreen == 4
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: "mytasks",
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitChasingDots(
      color: Colors.white,
      size: 25.0,
    );
  }
}

class ErrorMessage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final message;

  const ErrorMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }
}
