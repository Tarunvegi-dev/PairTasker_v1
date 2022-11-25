import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/helpers/methods.dart';

class TaskersList extends StatelessWidget {
  const TaskersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                        Container(
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
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/taskerprofile'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                'Will Smith',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '@willsmith143',
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
                    Text(
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
                            '4.8',
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
                            '10',
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
                            '10',
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
        Container(
          color: Helper.isDark(context) ? Colors.black : Colors.white,
          margin: const EdgeInsets.only(bottom: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'https://icustomercareinformation.in/wp-content/uploads/2021/05/virat-kohli.jpg',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/taskerprofile'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Virat Kohli',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
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
                        ),
                      ],
                    ),
                    Text(
                      'BUSY',
                      style: GoogleFonts.lato(
                        color: HexColor('#FF033E'),
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
                            '4.8',
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
                            '10',
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
                            '10',
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
                            width: 5,
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
        Container(
          color: Helper.isDark(context) ? Colors.black : Colors.white,
          margin: const EdgeInsets.only(bottom: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'https://icustomercareinformation.in/wp-content/uploads/2021/05/virat-kohli.jpg',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/taskerprofile'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Virat Kohli',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
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
                        ),
                      ],
                    ),
                    Text(
                      'AVAILABLE',
                      style: GoogleFonts.lato(
                        color: HexColor('#32DE84'),
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
                            '4.8',
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
                            '10',
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
                            '10',
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
                            width: 5,
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
      ],
    );
  }
}
