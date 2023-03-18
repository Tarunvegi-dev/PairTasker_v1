import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
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
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      setState(() {
        isTasker = userdata['isTasker'] ?? false;
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

  Future<void> acceptRequest(String taskId, bool accept) async {
    final response = await Provider.of<Tasker>(context, listen: false)
        .acceptRequest(taskId, accept);
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // ignore: use_build_context_synchronously
        backgroundColor: HexColor('007FFF'),
        content: Text(
          response.data['message'],
          style: GoogleFonts.poppins(
            // ignore: use_build_context_synchronously
            color: Helper.isDark(context) ? Colors.white : Colors.black,
          ),
        ),
      ));
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);
      Future.delayed(const Duration(seconds: 2), () {
        navigator.pushReplacementNamed('/mytasks');
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // ignore: use_build_context_synchronously
        backgroundColor: HexColor('FF033E'),
        content: Text(
          response.data['message'],
          style: GoogleFonts.poppins(
            // ignore: use_build_context_synchronously
            color: Helper.isDark(context) ? Colors.white : Colors.black,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<Tasker>(context).notifications;
    return Scaffold(
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
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (ctx, i) {
                  if (notifications[i]['type'] == 'task') {
                    return RequestNotification(
                        acceptRequest: acceptRequest,
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
      bottomNavigationBar: isTasker
          ? const TaskerBottomNavBarWidget(2)
          : const BottomNavBarWidget(2),
    );
  }
}
