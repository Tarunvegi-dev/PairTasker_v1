import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskerProfile extends StatelessWidget {
  const TaskerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
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
                  Icon(
                    Icons.close,
                    size: 34,
                    color: HexColor('99A4AE'),
                  ),
                  Text(
                    'ACTIVE',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor('32DE84'),
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: HexColor('FF033E'),
                    size: 34,
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: HexColor('#E4ECF5'),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.only(
                      top: 38,
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
                                  height: 42,
                                  width: 42,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      'https://icustomercareinformation.in/wp-content/uploads/2021/05/virat-kohli.jpg',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Virat Kohli',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '@viratkohli18',
                                      style: TextStyle(
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
                                child: const Text(
                                  'REQUEST',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
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
                                  '4.8',
                                  style: TextStyle(
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
                                  '10',
                                  style: TextStyle(
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
                                  style: TextStyle(
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
                          style: TextStyle(
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
                          color: Colors.white,
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
                                            'https://icustomercareinformation.in/wp-content/uploads/2021/05/virat-kohli.jpg',
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
                                          const Text(
                                            'Virat Kohli',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '@viratkohli18',
                                            style: TextStyle(
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
                                    style: TextStyle(
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
                                  style: TextStyle(
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
                          color: Colors.white,
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
                                            'https://icustomercareinformation.in/wp-content/uploads/2021/05/virat-kohli.jpg',
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
                                          const Text(
                                            'Virat Kohli',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '@viratkohli18',
                                            style: TextStyle(
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
                                    style: TextStyle(
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
                                  style: TextStyle(
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
