import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/screens/tasker_profile/tasker_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/user.dart';

class Recents extends StatefulWidget {
  const Recents({super.key});

  @override
  State<Recents> createState() => _RecentsState();
}

class _RecentsState extends State<Recents> {
  var _isInit = true;
  var _isLoading = false;
  List<dynamic> recentTaskers = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final response = await Provider.of<User>(context).getRecentTaskers();
      if (response.statusCode == 200) {
        setState(() {
          recentTaskers = response.data['data'];
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (recentTaskers.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: HexColor(
            Helper.isDark(context) ? '252B30' : '#E4ECF5',
          ),
        ),
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
                'Recents',
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
                  itemCount: recentTaskers.length,
                  itemBuilder: (BuildContext context, int i) => InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskerProfile(
                          id: recentTaskers[i]['id'],
                        ),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 25,
                      ),
                      child: Column(
                        children: [
                          Stack(children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: recentTaskers[i]['user']
                                          ['profilePicture'] ==
                                      null
                                  ? const AssetImage(
                                      'assets/images/default_user.png',
                                    )
                                  : NetworkImage(recentTaskers[i]['user']
                                      ['profilePicture']) as ImageProvider,
                            ),
                            Positioned(
                              right: 0,
                              left: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor(
                                    recentTaskers[i]['isOnline'] == true
                                        ? '#32DE84'
                                        : 'FF033E',
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
                            recentTaskers[i]['user']['displayName'],
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
