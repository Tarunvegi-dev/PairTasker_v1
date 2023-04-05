import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/screens/notifications/notification_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/widgets.dart';
import '../../helpers/methods.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _isInit = true;
  var _isLoading = false;
  var isTasker = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      setState(() {
        isTasker = Provider.of<Auth>(context, listen: false).isTasker;
      });
      // ignore: use_build_context_synchronously
      Provider.of<Tasker>(context, listen: false).getNotifications().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<Tasker>(context).notifications;
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              Provider.of<Tasker>(context, listen: false).getNotifications(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Helper.isDark(context) ? Colors.white : Colors.black,
                      width: 0.2,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (notifications.isEmpty && !_isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Helper.isDark(context) ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: const Center(
                    child: Text('No Notifications!'),
                  ),
                ),
              if (_isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  itemBuilder: (ctx, i) {
                    if (notifications[i]['type'] == 'task') {
                      return RequestNotification(
                          image: notifications[i]['image'] ?? '',
                          taskId: notifications[i]['taskId'],
                          description: notifications[i]['description'],
                          profilePicture: notifications[i]['user']
                              ['profilePicture'],
                          username: notifications[i]['user']['displayName']);
                    } else if (notifications[i]['type'] == 'warning') {
                      return const WarningNotification();
                    } else {
                      return const AnnouncementNotification();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isTasker
          ? const TaskerBottomNavBarWidget(2)
          : const BottomNavBarWidget(2),
    );
  }
}
