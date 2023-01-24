import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:provider/provider.dart';
import '../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskerProfile extends StatefulWidget {
  final id;

  const TaskerProfile({this.id, super.key});

  @override
  State<TaskerProfile> createState() => _TaskerProfileState();
}

class _TaskerProfileState extends State<TaskerProfile> {
  var _isInit = true;
  String username = '';
  String displayName = '';
  String rating = '';
  String totalTasks = '';
  String profilePicture = '';
  bool isWishlisted = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final response = await Provider.of<Tasker>(context, listen: false)
          .getTaskerDetails(widget.id);
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      var wishlist = userdata['wishlist'] as List<dynamic>;
      setState(() {
        isWishlisted = wishlist.contains(widget.id) != false;
      });
      if (response.data['status'] == true) {
        var taskerData = response.data['data'];
        setState(() {
          profilePicture = taskerData['user']['profilePicture'] ?? '';
          username = taskerData['user']['username'] ?? '';
          displayName = taskerData['user']['displayName'] ?? '';
          rating = taskerData['rating'].toString();
          totalTasks = taskerData['totalTasks'].toString();
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> handleWishlist() async {
    final response = await Provider.of<User>(context, listen: false)
        .manageWishlist(widget.id, !isWishlisted);
    if (response.statusCode == 200) {
      setState(() {
        isWishlisted = !isWishlisted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 34,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  Text(
                    'ACTIVE',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor('32DE84'),
                    ),
                  ),
                  InkWell(
                    onTap: handleWishlist,
                    child: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: HexColor(isWishlisted ? 'FF033E' : 'FFFFFF'),
                      size: 34,
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Helper.isDark(context)
                    ? HexColor('252B30')
                    : HexColor('DEE0E0'),
              ),
              child: Column(
                children: [
                  Container(
                    color: Helper.isDark(context) ? Colors.black : Colors.white,
                    padding: const EdgeInsets.only(
                      top: 28,
                      left: 26,
                      right: 20,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 37,
                                  width: 37,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: profilePicture != ''
                                        ? NetworkImage(
                                            profilePicture,
                                          )
                                        : const AssetImage(
                                            'assets/images/default_user.png',
                                          ) as ImageProvider,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
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
                                        fontSize: 12,
                                        color: HexColor('#AAABAB'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  backgroundColor: HexColor('007FFF'),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 25,
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'REQUEST',
                                  style: GoogleFonts.lato(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: HexColor('#FFC72C'),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  rating,
                                  style: GoogleFonts.lato(
                                    color: HexColor('#AAABAB'),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  child: SvgPicture.asset(
                                    'assets/images/icons/task.svg',
                                    height: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  totalTasks,
                                  style: GoogleFonts.lato(
                                    color: HexColor('#AAABAB'),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: HexColor('#007FFF'),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '2 km',
                                  style: GoogleFonts.lato(
                                    color: HexColor('#AAABAB'),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          'Reviews',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            color: HexColor('99A4AE'),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 3,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          color: Helper.isDark(context)
                              ? Colors.black
                              : Colors.white,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 32,
                                        width: 32,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            'https://m.cricbuzz.com/a/img/v1/192x192/i1/c244980/virat-kohli.jpg',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Virat Kohli',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '@viratkohli18',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: HexColor('#AAABAB'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '3w',
                                    style: GoogleFonts.lato(
                                      color: HexColor('99A4AE'),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  'You have to be quick',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.lato(
                                    color: HexColor('99A4AE'),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Helper.isDark(context)
                              ? Colors.black
                              : Colors.white,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 32,
                                        width: 32,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            'https://m.cricbuzz.com/a/img/v1/192x192/i1/c244980/virat-kohli.jpg',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Virat Kohli',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '@viratkohli18',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: HexColor('#AAABAB'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '3w',
                                    style: GoogleFonts.lato(
                                      color: HexColor('99A4AE'),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  'You have to be quick',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.lato(
                                    color: HexColor('99A4AE'),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          'Give Feedback',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
