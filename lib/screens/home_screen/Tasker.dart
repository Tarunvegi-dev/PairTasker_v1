// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/screens/screens.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TaskerWidget extends StatelessWidget {
  final index;
  final username;
  final id;
  final displayName;
  final rating;
  final tasks;
  final saves;
  final profilePicture;
  final isSelected;
  final availability;
  final List<dynamic> selectedTaskers;
  final Function selectTaskers;

  const TaskerWidget(
      {this.index,
      this.id,
      this.username,
      this.displayName,
      this.rating,
      this.saves,
      this.tasks,
      this.profilePicture,
      this.isSelected,
      this.availability,
      required this.selectedTaskers,
      required this.selectTaskers,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => isSelected ? null : selectTaskers(id),
      onTap: () =>
          isSelected || selectedTaskers.isNotEmpty ? selectTaskers(id) : null,
      child: Container(
        color: Helper.isDark(context) ? Colors.black : Colors.white,
        margin: const EdgeInsets.only(
          bottom: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      isSelected
                          ? Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(125),
                                ),
                                color: HexColor('#007FFF'),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          : SizedBox(
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
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskerProfile(
                              username: username,
                              displayName: displayName,
                              profilePicture: profilePicture,
                              rating: rating,
                              tasks: tasks,
                              id: id,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '@$username',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: HexColor('#AAABAB'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  !isSelected
                      ? LinearPercentIndicator(
                          backgroundColor: HexColor('FF0303'),
                          progressColor: HexColor('00CE15'),
                          percent: availability / 100,
                          width: 100.0,
                          lineHeight: 8.0,
                          trailing: Text(
                            '$availability%',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          barRadius: const Radius.circular(25),
                        )
                      : Text(
                          'SELECTED',
                          style: GoogleFonts.lato(
                            color: HexColor('#007FFF'),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: HexColor('#FFC72C'),
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          rating,
                          style: GoogleFonts.lato(
                            color: HexColor('#AAABAB'),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: HexColor('#FF033E'),
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          saves,
                          style: GoogleFonts.lato(
                            color: HexColor('#AAABAB'),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: SvgPicture.asset(
                            'assets/images/icons/task.svg',
                            height: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          tasks,
                          style: GoogleFonts.lato(
                            color: HexColor('#AAABAB'),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: HexColor('#007FFF'),
                          size: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '2 km',
                          style: GoogleFonts.lato(
                            color: HexColor('#AAABAB'),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
