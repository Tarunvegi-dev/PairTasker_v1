import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/screens/screens.dart';
import '../theme/widgets.dart';

class MyRequests extends StatelessWidget {
  const MyRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 8 / 100,
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
                vertical: 20,
              ),
              child: Text(
                'My Requests',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: HexColor('#E4ECF5'),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen('user'),
                      ),
                    ),
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 5),
                      height: 120,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'PT00001A',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '@willsmith14',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: HexColor('AAABAB'),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  'Requested',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: HexColor('007FFF'),
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
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 120,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'PT00001A',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '@willsmith14',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: HexColor('AAABAB'),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                color: HexColor('FFC72C'),
                                padding: const EdgeInsets.all(6),
                                child: const Text(
                                  'CHAT',
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
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 120,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'PT00001A',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '@willsmith14',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: HexColor('AAABAB'),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                color: HexColor('007FFF'),
                                padding: const EdgeInsets.all(7),
                                child: const Text(
                                  'CONFIRMED',
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
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 120,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'PT00001A',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '@willsmith14',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: HexColor('AAABAB'),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                color: HexColor('32DE84'),
                                padding: const EdgeInsets.all(7),
                                child: const Text(
                                  'COMPLETED',
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
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 120,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'PT00001A',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '@willsmith14',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: HexColor('AAABAB'),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                color: HexColor('FF033E'),
                                padding: const EdgeInsets.all(7),
                                child: const Text(
                                  'CANCELLED',
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
      bottomNavigationBar: const BottomNavBarWidget(2),
    );
  }
}
