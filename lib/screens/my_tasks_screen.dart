import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/screens/screens.dart';
import '../theme/widgets.dart';
import '../helpers/methods.dart';

class MyTasks extends StatelessWidget {
  const MyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 8 / 100,
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
            Container(
              decoration: BoxDecoration(
                color: HexColor(Helper.isDark(context) ? '252B30' : '#E4ECF5'),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen('tasker'),
                      ),
                    ),
                    child: Container(
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
                      margin: const EdgeInsets.only(bottom: 5),
                      height: 130,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Virat Kohli',
                                          style: TextStyle(
                                            fontSize: 14,
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
                                Container(
                                  color: HexColor('FFC72C'),
                                  padding: const EdgeInsets.all(6),
                                  child: const Text(
                                    'DEALING',
                                    style: TextStyle(
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
                            Text(
                              'Naaku oka 2 liters milk packet kaavali. And some vegetables. I will pay you 40 rupees  .......more.',
                              style: TextStyle(
                                color: HexColor('6F7273'),
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Helper.isDark(context) ? Colors.black : Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 130,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Virat Kohli',
                                        style: TextStyle(
                                          fontSize: 14,
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
                              Container(
                                color: HexColor('007FFF'),
                                padding: const EdgeInsets.all(7),
                                child: const Text(
                                  'AGREED',
                                  style: TextStyle(
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
                          Text(
                            'Naaku oka 2 liters milk packet kaavali. And some vegetables. I will pay you 40 rupees  .......more.',
                            style: TextStyle(
                              color: HexColor('6F7273'),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Helper.isDark(context) ? Colors.black : Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 130,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Virat Kohli',
                                        style: TextStyle(
                                          fontSize: 14,
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
                              Container(
                                color: HexColor('32DE84'),
                                padding: const EdgeInsets.all(7),
                                child: const Text(
                                  'TASK DONE',
                                  style: TextStyle(
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
                          Text(
                            'Naaku oka 2 liters milk packet kaavali. And some vegetables. I will pay you 40 rupees  .......more.',
                            style: TextStyle(
                              color: HexColor('6F7273'),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Helper.isDark(context) ? Colors.black : Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 130,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Virat Kohli',
                                        style: TextStyle(
                                          fontSize: 14,
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
                              Container(
                                color: HexColor('FF033E'),
                                padding: const EdgeInsets.all(7),
                                child: const Text(
                                  'TERMINATED',
                                  style: TextStyle(
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
                          Text(
                            'Naaku oka 2 liters milk packet kaavali. And some vegetables. I will pay you 40 rupees  .......more.',
                            style: TextStyle(
                              color: HexColor('6F7273'),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(4),
    );
  }
}
