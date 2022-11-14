import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/screens/home_screen/taskers_list.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: HexColor('99A4AE'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Search....',
                  style: TextStyle(
                    color: HexColor('99A4AE'),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor('007FFF'),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      'Mechanic',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      'Delivery Boy',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      'Cameraman',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      'Cook',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: HexColor('#E4ECF5'),
            ),
            child: ListView(
              shrinkWrap: true,
              children: const [TaskersList()],
            ),
          )
        ],
      )),
    );
  }
}
