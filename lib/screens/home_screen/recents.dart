import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class Recents extends StatelessWidget {
  const Recents({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      right: 25,
                    ),
                    child: Column(
                      children: [
                        Stack(children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://m.cricbuzz.com/a/img/v1/192x192/i1/c244982/rohit-sharma.jpg',
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 35,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor('#32DE84'),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          'Rohit Sharma',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 25,
                    ),
                    child: Column(
                      children: [
                        Stack(children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/premium-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg?w=2000',
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 35,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor('#32DE84'),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          'Virat Kohli',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 25,
                    ),
                    child: Column(
                      children: [
                        Stack(children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjdKRG2b-Z-wzIFPlATwulI-kKBy9LiKNcpAdBG4u5mf2X3aVPp2p62JYts9jz-1ABOnI&usqp=CAU',
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 35,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor('#32DE84'),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          'Elliot Alderson',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 25,
                    ),
                    child: Column(
                      children: [
                        Stack(children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/premium-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg?w=2000',
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 35,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor('#32DE84'),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          'Will Smith',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 25,
                    ),
                    child: Column(
                      children: [
                        Stack(children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://i0.wp.com/thecitylife.org/wp-content/uploads/2021/02/011_BOSS_ChrisHemsworth_SR21.jpg?fit=1025%2C1536&ssl=1',
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 35,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor('#32DE84'),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          'Chris Hemsworth',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
