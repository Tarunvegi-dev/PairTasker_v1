import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/screens/my_tasks/task_widget.dart';
import '../../theme/widgets.dart';
import '../../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'dart:convert';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key});

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  List<dynamic> loadedTasks = [];
  bool isLoading = false;
  Map<String, dynamic> unreadMessages = {};
  String userId = '';

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });
    checkUnreadMessages();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    setState(() {
      userId = userdata['id'].toString();
    });
    final tasksPref = prefs.getString('tasks');
    Map<String, dynamic> tasksData =
        jsonDecode(tasksPref!) as Map<String, dynamic>;
    if (tasksData['active'].length > 0) {
      // ignore: use_build_context_synchronously
      final response = await Provider.of<Tasker>(context, listen: false)
          .getMyTasks(active: true);
      setState(() {
        loadedTasks = response['active'];
        loadedTasks.addAll(response['completed']);
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        loadedTasks = tasksData['active'];
        loadedTasks.addAll(tasksData['completed']);
        isLoading = false;
      });
    }
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
  void initState() {
    fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchTasks,
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
                  'My Tasks',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (loadedTasks.isEmpty && !isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Helper.isDark(context) ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: const Center(
                    child: Text('No Tasks Found!'),
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
                  itemCount: loadedTasks.length,
                  itemBuilder: (BuildContext context, int i) => TaskWidget(
                    id: loadedTasks[i]['id'],
                    fetchTasks: fetchTasks,
                    unreadCount:
                        unreadMessages.containsKey(loadedTasks[i]['id'])
                            ? unreadMessages[loadedTasks[i]['id']]
                            : 0,
                    isTerminated: loadedTasks[i]['currentTasker'].toString() != userId,
                    username: loadedTasks[i]['user']['username'],
                    displayName: loadedTasks[i]['user']['displayName'],
                    profilePicture: loadedTasks[i]['user']['profilePicture'],
                    status: loadedTasks[i]['status'],
                    message: loadedTasks[i]['message'],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TaskerBottomNavBarWidget(1),
    );
  }
}
