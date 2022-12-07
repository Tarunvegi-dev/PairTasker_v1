import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';
import '../theme/theme.dart';

class TaskerDetails extends StatelessWidget {
  const TaskerDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 75, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Working Categories',
                    style: PairTaskerTheme.title3,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'search category..',
                      hintStyle: GoogleFonts.lato(
                        fontSize: 14,
                        color: HexColor('6F7273'),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: HexColor('AAABAB'),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 50,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: HexColor('AAABAB'),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    'Working Categories',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HexColor('6F7273')),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Wrap(
                    spacing: 5.0,
                    runSpacing: 15.0,
                    children: [
                      Container(
                        width: 100,
                        height: 24,
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor('007FFF'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Mechanic',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              Image.asset(
                                "assets/images/icons/close.png",
                                height: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 24,
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor('007FFF'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Mechanic',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              Image.asset(
                                "assets/images/icons/close.png",
                                height: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 24,
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor('007FFF'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Photographer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              Image.asset(
                                "assets/images/icons/close.png",
                                height: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 24,
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor('007FFF'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery Boy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              Image.asset(
                                "assets/images/icons/close.png",
                                height: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                        backgroundColor: HexColor('007FFF'),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/home'),
                      child: Text(
                        'Save',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
