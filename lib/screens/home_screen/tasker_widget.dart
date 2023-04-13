// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/screens/screens.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TaskerWidget extends StatefulWidget {
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
  final workingCategories;
  final isWishlist;
  final List<dynamic> selectedTaskers;
  final Function selectTaskers;
  final isVerified;

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
      this.isVerified,
      this.workingCategories,
      required this.selectedTaskers,
      required this.selectTaskers,
      this.isWishlist = false,
      super.key});

  @override
  State<TaskerWidget> createState() => _TaskerWidgetState();
}

class _TaskerWidgetState extends State<TaskerWidget> {
  TutorialCoachMark tutorialCoachMark = TutorialCoachMark(targets: []);
  List<TargetFocus> targets = [];
  final GlobalKey _key = GlobalKey();
  var newUser = 'false';

  @override
  void initState() {
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(_) {
    Future.delayed(const Duration(milliseconds: 1000), showTutorial);
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: HexColor('007FFF'),
      opacityShadow: 0.5,
    )..show(
        context: context,
      );
  }

  void initTargets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (prefs.containsKey('newUser')) {
      setState(() {
        newUser = prefs.getString('newUser') as String;
      });
      Future.delayed(const Duration(seconds: 500), () {
        setState(() {
          newUser = 'false';
        });
      });
      prefs.setString('newUser', 'false');
    }
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: _key,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                "Long press on any tasker to send a request",
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: HexColor('007FFF'),
                ),
              ),
            ),
          )
        ],
      ),
    );
    tutorialCoachMark = TutorialCoachMark(targets: targets);
  }

  @override
  Widget build(BuildContext context) {
    final workingCategories = widget.workingCategories
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(' ');
    return Column(
      children: [
        InkWell(
          onLongPress: () => widget.isSelected || widget.isWishlist
              ? null
              : widget.selectTaskers(widget.id),
          onTap: () =>
              (widget.isSelected || widget.selectedTaskers.isNotEmpty) &&
                      !widget.isWishlist
                  ? widget.selectTaskers(widget.id)
                  : null,
          child: Container(
            color: Helper.isDark(context) ? Colors.black : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          widget.isSelected
                              ? Container(
                                  height: 45,
                                  width: 45,
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
                              : InkWell(
                                  onTap: widget.selectedTaskers.isEmpty
                                      ? () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskerProfile(
                                                id: widget.id,
                                              ),
                                            ),
                                          )
                                      : null,
                                  child: SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: CircleAvatar(
                                      key:
                                          widget.index == 0 && newUser == 'true'
                                              ? _key
                                              : ValueKey(
                                                  widget.index,
                                                ),
                                      radius: 30,
                                      backgroundImage: widget.profilePicture ==
                                              null
                                          ? const AssetImage(
                                              'assets/images/default_user.png',
                                            )
                                          : NetworkImage(widget.profilePicture)
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TaskerProfile(
                                  id: widget.id,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.displayName,
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (widget.isVerified)
                                      Image.asset(
                                        'assets/images/icons/verified_badge.png',
                                        width: 16,
                                        height: 20,
                                      )
                                  ],
                                ),
                                Text(
                                  '@${widget.username}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    color: HexColor('#AAABAB'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      !widget.isSelected
                          ? AnimatedTextKit(
                              animatedTexts: workingCategories
                                  .map(
                                    (category) => TyperAnimatedText(
                                      category
                                          .toUpperCase()
                                          .replaceAll(',', ''),
                                      textStyle: GoogleFonts.nunito(
                                        color: HexColor('#AAABAB'),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              repeatForever: true,
                              isRepeatingAnimation: true,
                            )
                          : Text(
                              'SELECTED',
                              style: GoogleFonts.nunito(
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
                              widget.rating,
                              style: GoogleFonts.nunito(
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
                              widget.saves,
                              style: GoogleFonts.nunito(
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
                              widget.tasks,
                              style: GoogleFonts.nunito(
                                color: HexColor('#AAABAB'),
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              widget.availability == 0
                                  ? Icons.wifi_off
                                  : Icons.wifi,
                              color: widget.availability < 33.3
                                  ? HexColor('FF033E')
                                  : widget.availability > 33.33 &&
                                          widget.availability < 66.66
                                      ? HexColor('FFC72C')
                                      : HexColor('#00CE15'),
                              size: 18,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${widget.availability}%',
                              style: GoogleFonts.nunito(
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
        ),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: HexColor(
              Helper.isDark(context) ? '252B30' : '#E4ECF5',
            ),
          ),
        )
      ],
    );
  }
}
