import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskersList extends StatelessWidget {
  const TaskersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 3),
          height: MediaQuery.of(context).size.height * 13 / 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
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
                          margin: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Will Smith',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '@willsmith143',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor('#AAABAB'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      'SELECTED',
                      style: TextStyle(
                        color: HexColor('#007FFF'),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
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
                          Icon(
                            Icons.favorite,
                            color: HexColor('#FF033E'),
                            size: 20,
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
                          Icon(Icons.location_on_rounded,
                              color: HexColor('#007FFF'), size: 20),
                          const SizedBox(
                            width: 4,
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
                )
              ],
            ),
          ),
        ),
         Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 3),
          height: MediaQuery.of(context).size.height * 13 / 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
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
                          width: 12,
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
                    Text(
                      'BUSY',
                      style: TextStyle(
                        color: HexColor('#FF033E'),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
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
                          Icon(
                            Icons.favorite,
                            color: HexColor('#FF033E'),
                            size: 20,
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
                )
              ],
            ),
          ),
        ),
         Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 3),
          height: MediaQuery.of(context).size.height * 13 / 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
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
                          width: 12,
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
                    Text(
                      'BUSY',
                      style: TextStyle(
                        color: HexColor('#FF033E'),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
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
                          Icon(
                            Icons.favorite,
                            color: HexColor('#FF033E'),
                            size: 20,
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
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
