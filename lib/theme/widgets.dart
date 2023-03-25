import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';
import '../helpers/methods.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBarWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectedScreen;

  const BottomNavBarWidget(
    this.selectedScreen, {
    super.key,
  });

  final List<Widget> screens = const [
    HomePage(),
    MyRequests(),
    NotificationScreen(),
    WishlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = Provider.of<Auth>(context).unreadNotifications;
    final unreadRequests = Provider.of<Auth>(context).unreadRequests;
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
        height: MediaQuery.of(context).size.height * 8 / 100,
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
            if (value == 1) {
              Provider.of<Auth>(context, listen: false)
                  .updateUnread('requests', false);
            }
            if (value == 2) {
              Provider.of<Auth>(context, listen: false)
                  .updateUnread('notifications', false);
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
              icon: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/images/icons/navbar/my_requests.svg",
                    width: 25,
                    color: selectedScreen == 1
                        ? HexColor('007FFF')
                        : HexColor('99A4AE'),
                  ),
                  if (unreadRequests)
                    Positioned(
                      right: 0,
                      left: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor('FF033E'),
                        ),
                        width: 8,
                        height: 8,
                      ),
                    )
                ],
              ),
              label: 'MyRequests',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/images/icons/navbar/notifications.svg",
                    width: 25,
                    color: selectedScreen == 2
                        ? HexColor('007FFF')
                        : HexColor('99A4AE'),
                  ),
                  if (unreadNotifications)
                    Positioned(
                      right: 0,
                      left: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor('FF033E'),
                        ),
                        width: 8,
                        height: 8,
                      ),
                    )
                ],
              ),
              label: "notifications",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/wishlist.svg",
                width: 23,
                color: selectedScreen == 3
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: 'Wishlist',
            ),
          ],
        ),
      ),
    );
  }
}

class TaskerBottomNavBarWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectedScreen;

  const TaskerBottomNavBarWidget(this.selectedScreen, {super.key});

  final List<Widget> screens = const [
    TaskerDashboard(),
    MyTasks(),
    NotificationScreen(),
    MyTaskerProfile()
  ];

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = Provider.of<Auth>(context).unreadNotifications;
    final unreadTasks = Provider.of<Auth>(context).unreadTasks;
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
        height: MediaQuery.of(context).size.height * 8 / 100,
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
            if (value == 1) {
              Provider.of<Auth>(context, listen: false)
                  .updateUnread('tasks', false);
            }
            if (value == 2) {
              Provider.of<Auth>(context, listen: false).updateUnread(
                'notifications',
                false,
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/dashboard.svg",
                width: 27,
                color: selectedScreen == 0
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/images/icons/navbar/my_tasks.svg",
                    width: 25,
                    color: selectedScreen == 1
                        ? HexColor('007FFF')
                        : HexColor('99A4AE'),
                  ),
                  if (unreadTasks)
                    Positioned(
                      right: 0,
                      left: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor('FF033E'),
                        ),
                        width: 8,
                        height: 8,
                      ),
                    )
                ],
              ),
              label: "mytasks",
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/images/icons/navbar/notifications.svg",
                    width: 25,
                    color: selectedScreen == 2
                        ? HexColor('007FFF')
                        : HexColor('99A4AE'),
                  ),
                  if (unreadNotifications)
                    Positioned(
                      right: 0,
                      left: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor('FF033E'),
                        ),
                        width: 8,
                        height: 8,
                      ),
                    )
                ],
              ),
              label: "notifications",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/icons/navbar/profile.svg",
                width: 25,
                color: selectedScreen == 3
                    ? HexColor('007FFF')
                    : HexColor('99A4AE'),
              ),
              label: "tasker profile",
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
