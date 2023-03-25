import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/screens/screens.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:hexcolor/hexcolor.dart';

class TaskWidget extends StatelessWidget {
  final username;
  final id;
  final displayName;
  final profilePicture;
  final status;
  final message;
  final fetchTasks;
  final unreadCount;
  final isTerminated;

  const TaskWidget(
      {this.username,
      this.displayName,
      this.profilePicture,
      this.message,
      this.status,
      this.id,
      this.fetchTasks,
      this.isTerminated,
      this.unreadCount,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed('/chatscreen', arguments: {
            "screenType": 'tasker',
            "taskId": id.toString(),
          }).then((value) {
            fetchTasks();
          }),
          child: Container(
            color: Helper.isDark(context) ? Colors.black : Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: profilePicture == null
                                  ? const AssetImage(
                                      'assets/images/default_user.png',
                                    )
                                  : NetworkImage(profilePicture)
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '@$username',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: HexColor('#AAABAB'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        color: HexColor(
                          isTerminated
                              ? 'FF033E'
                              : status == '1'
                                  ? 'FFC72C'
                                  : status == '2'
                                      ? '007FFF'
                                      : status == '3'
                                          ? '32DE84'
                                          : 'FF033E',
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          isTerminated
                              ? 'TERMINATED'
                              : status == '1'
                                  ? 'DEALING'
                                  : status == '2'
                                      ? 'AGREED'
                                      : status == '3'
                                          ? 'TASK DONE'
                                          : 'TERMINATED',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message,
                        style: GoogleFonts.lato(
                          color: HexColor('6F7273'),
                          fontSize: 14,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: HexColor('007FFF'),
                            shape: BoxShape.circle,
                          ),
                          child: Text(unreadCount.toString()),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: HexColor(
              Helper.isDark(context) ? '252B30' : '#E4ECF5',
            ),
          ),
          height: 4,
        )
      ],
    );
  }
}
