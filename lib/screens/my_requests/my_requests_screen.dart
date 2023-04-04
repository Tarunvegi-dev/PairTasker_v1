import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/screens/my_requests/request_widget.dart';
import 'package:provider/provider.dart';
import '../../theme/widgets.dart';
import '../../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  List<dynamic> loadedRequests = [];
  bool isLoading = false;
  Map<String, dynamic> unreadMessages = {};

  Future<void> fetchRequests() async {
    setState(() {
      isLoading = true;
    });
    checkUnreadMessages();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final requestPref = prefs.getString('requests');
    Map<String, dynamic> requestsdata =
        jsonDecode(requestPref!) as Map<String, dynamic>;
    if (requestsdata['active'].length > 0) {
      // ignore: use_build_context_synchronously
      final response = await Provider.of<User>(
        context,
        listen: false,
      ).getMyRequests(active: true);
      setState(() {
        loadedRequests = response['active'];
        loadedRequests.addAll(requestsdata['completed']);
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        loadedRequests = requestsdata['active'];
        loadedRequests.addAll(requestsdata['completed']);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchRequests();
    super.initState();
  }

  void checkUnreadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (prefs.containsKey('unread-messages')) {
      final pendingPref = prefs.getString('unread-messages');
      Map<String, dynamic> pendingData =
          jsonDecode(pendingPref!) as Map<String, dynamic>;
      setState(() {
        unreadMessages = pendingData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchRequests,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 8 / 100,
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
                  'My Requests',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (loadedRequests.isEmpty && !isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Helper.isDark(context) ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: const Center(
                    child: Text('No Requests Found!'),
                  ),
                ),
              if (isLoading)
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
                    itemCount: loadedRequests.length,
                    itemBuilder: (ctx, i) {
                      return RequestWidget(
                        unreadCount:
                            unreadMessages.containsKey(loadedRequests[i]['id'])
                                ? unreadMessages[loadedRequests[i]['id']]
                                : 0,
                        requestId: loadedRequests[i]['reqId'],
                        id: loadedRequests[i]['id'],
                        fetchRequests: fetchRequests,
                        message: loadedRequests[i]['message'],
                        status: loadedRequests[i]['status'],
                        currentTasker: loadedRequests[i]['tasker'] != null
                            ? loadedRequests[i]['tasker']['user']['username']
                            : '',
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(1),
    );
  }
}
