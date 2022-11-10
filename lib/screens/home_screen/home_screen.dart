import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/screens/home_screen/taskers_list.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'recents.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
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
                  Row(
                    children: [
                      InkWell(
                        onTap: () => key.currentState?.openDrawer(),
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(
                            right: 12,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(125),
                            ),
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () => key.currentState?.openDrawer(),
                              child: SvgPicture.asset(
                                'assets/images/icons/menu.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: HexColor('#007FFF'),
                            size: 20,
                          ),
                          Text(
                            'Guntur, AP',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(125),
                        ),
                        color: HexColor('007FFF'),
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: HexColor('#E4ECF5'),
              ),
              child: ListView(
                shrinkWrap: true,
                children: const [
                  Recents(),
                  TaskersList(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(0),
    );
  }
}
