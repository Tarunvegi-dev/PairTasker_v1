import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/screens/chat_screen/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/tasker.dart';

class ActiveTasks extends StatefulWidget {
  const ActiveTasks({super.key});

  @override
  State<ActiveTasks> createState() => _ActiveTasksState();
}

class _ActiveTasksState extends State<ActiveTasks> {
  var _isInit = true;
  var _isLoading = false;
  List<dynamic> activeTasks = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final response =
          await Provider.of<Tasker>(context).getMyTasks(active: true);
      setState(() {
        activeTasks = response['active'];
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (activeTasks.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 100,
        height: MediaQuery.of(context).size.height * 16 / 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              child: Text(
                'Active Tasks',
                style: GoogleFonts.lato(
                  color: HexColor('#AAABAB'),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 25,
              ),
              width: MediaQuery.of(context).size.width * 100,
              height: MediaQuery.of(context).size.height * 9 / 100,
              child: ScrollConfiguration(
                behavior:
                    const MaterialScrollBehavior().copyWith(overscroll: false),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: activeTasks.length,
                  itemBuilder: (BuildContext context, int i) => InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed('/chatscreen', arguments: {
                      "screenType": 'tasker',
                      "taskId": activeTasks[i]['id'],
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 25,
                      ),
                      child: Column(
                        children: [
                          Stack(children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: activeTasks[i]['user']
                                          ['profilePicture'] ==
                                      null
                                  ? const AssetImage(
                                      'assets/images/default_user.png',
                                    )
                                  : NetworkImage(activeTasks[i]['user']
                                      ['profilePicture']) as ImageProvider,
                            ),
                            Positioned(
                              right: 0,
                              left: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor(
                                    activeTasks[i]['status'] == "1"
                                        ? '#FFC72C'
                                        : '007FFF',
                                  ),
                                ),
                                width: 10,
                                height: 10,
                              ),
                            )
                          ]),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            activeTasks[i]['user']['displayName'],
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 5,
      );
    }
  }
}
