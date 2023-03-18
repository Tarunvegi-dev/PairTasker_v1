import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/screens/home_screen/drawer.dart';
import 'package:pairtasker/screens/home_screen/tasker_widget.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth.dart';
import 'recents.dart';
import '../../helpers/methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> key = GlobalKey();
  final List<dynamic> _workingCategories = ['deliveryboy'];
  List<dynamic> filteredTaskers = [];
  var _isInit = true;
  var _isLoading = false;
  String sortCategory = 'rating';
  String address = '';

  @override
  void didChangeDependencies() async {
    final prefs = await SharedPreferences.getInstance();
    final a = prefs.getString('address');
    setState(() {
      address = a.toString();
    });
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // ignore: use_build_context_synchronously
      Provider.of<Auth>(context, listen: false).updateGeoLocation();
      searchTaskers().then((_) {
        setState(() {
          _isLoading = false;
          address = a.toString();
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<dynamic> selectedTaskers = [];

  void selectTaskers(String id) {
    if (selectedTaskers.contains(id)) {
      setState(() {
        selectedTaskers.remove(id);
      });
    } else {
      setState(() {
        selectedTaskers.add(id);
      });
    }
  }

  Future<void> sortTaskers() async {
    Provider.of<User>(context, listen: false).getTaskers(
      sortBy: sortCategory,
      sort: true,
    );
  }

  Future<void> _refreshTaskers() async {
    await Provider.of<User>(context, listen: false).getTaskers();
  }

  Future<void> searchTaskers() async {
    final response = await Provider.of<User>(context, listen: false).getTaskers(
      search: true,
      keyword: '',
      workingCategories: _workingCategories.join(" "),
    );
    setState(() {
      filteredTaskers = response;
    });
  }

  void manageWorkingCategories(category) {
    setState(() {
      _workingCategories.removeRange(0, _workingCategories.length);
      _workingCategories.add(category.toString().trim());
    });
    searchTaskers();
  }

  void showSort() {
    showMenu(
      position: const RelativeRect.fromLTRB(100, 0, 0, 0),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: InkWell(
            onTap: () {
              setState(() {
                sortCategory = 'rating';
              });
              sortTaskers();
              Navigator.of(context).pop();
            },
            child: Row(children: [
              Radio(
                activeColor: HexColor('007fff'),
                value: 'rating',
                groupValue: sortCategory,
                onChanged: (value) {},
              ),
              Text(
                'Rating',
                style: GoogleFonts.lato(
                  fontSize: 14,
                ),
              )
            ]),
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: InkWell(
            onTap: () {
              setState(() {
                sortCategory = 'saves';
              });
              sortTaskers();
              Navigator.of(context).pop();
            },
            child: Row(children: [
              Radio(
                activeColor: HexColor('007fff'),
                value: 'saves',
                groupValue: sortCategory,
                onChanged: (value) {},
              ),
              Text(
                'Wishlist',
                style: GoogleFonts.lato(
                  fontSize: 14,
                ),
              )
            ]),
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: InkWell(
            onTap: () {
              setState(() {
                sortCategory = 'totalTasks';
              });
              sortTaskers();
              Navigator.of(context).pop();
            },
            child: Row(children: [
              Radio(
                activeColor: HexColor('007fff'),
                value: 'totalTasks',
                groupValue: sortCategory,
                onChanged: (value) {},
              ),
              Text(
                'Total tasks',
                style: GoogleFonts.lato(
                  fontSize: 14,
                ),
              )
            ]),
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: InkWell(
            onTap: () {
              setState(() {
                sortCategory = 'availability';
              });
              sortTaskers();
              Navigator.of(context).pop();
            },
            child: Row(children: [
              Radio(
                activeColor: HexColor('007fff'),
                value: 'availability',
                groupValue: sortCategory,
                onChanged: (value) {},
              ),
              Text(
                'Availability',
                style: GoogleFonts.lato(
                  fontSize: 14,
                ),
              )
            ]),
          ),
        ),
      ],
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      drawer: const DrawerWidget(),
      body: Builder(
        builder: (context) => SafeArea(
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
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.only(
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(125),
                              ),
                              color: Helper.isDark(context)
                                  ? const Color.fromRGBO(242, 242, 243, 0.35)
                                  : const Color.fromRGBO(0, 0, 0, 0.1),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () => Scaffold.of(context).openDrawer(),
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
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              address,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed('/searchscreen'),
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
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          child: InkWell(
                            onTap: () => showSort(),
                            child: Container(
                              width: 36,
                              height: 36,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(125),
                                ),
                                color: Helper.isDark(context)
                                    ? const Color.fromRGBO(242, 242, 243, 0.35)
                                    : const Color.fromRGBO(0, 0, 0, 0.1),
                              ),
                              child: SvgPicture.asset(
                                "assets/images/icons/filter.svg",
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: HexColor(
                    Helper.isDark(context) ? '252B30' : '#E4ECF5',
                  ),
                ),
                child: RefreshIndicator(
                  onRefresh: _refreshTaskers,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            InkWell(
                              onTap: () => manageWorkingCategories('Mechanic'),
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: _workingCategories.contains('Mechanic')
                                      ? HexColor('007FFF')
                                      : Helper.isDark(context)
                                          ? const Color.fromRGBO(
                                              255, 255, 255, 0.1)
                                          : const Color.fromRGBO(0, 0, 0, 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Mechanic',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  manageWorkingCategories('deliveryboy'),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 1,
                                ),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: _workingCategories
                                          .contains('deliveryboy')
                                      ? HexColor('007FFF')
                                      : Helper.isDark(context)
                                          ? const Color.fromRGBO(
                                              255, 255, 255, 0.1)
                                          : const Color.fromRGBO(0, 0, 0, 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Delivery Boy',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  manageWorkingCategories('Photographer'),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 1,
                                ),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: _workingCategories
                                          .contains('Photographer')
                                      ? HexColor('007FFF')
                                      : Helper.isDark(context)
                                          ? const Color.fromRGBO(
                                              255, 255, 255, 0.1)
                                          : const Color.fromRGBO(0, 0, 0, 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Photographer',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => manageWorkingCategories('Rider'),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 1,
                                ),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: _workingCategories.contains('Rider')
                                      ? HexColor('007FFF')
                                      : Helper.isDark(context)
                                          ? const Color.fromRGBO(
                                              255, 255, 255, 0.1)
                                          : const Color.fromRGBO(0, 0, 0, 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Rider',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Recents(),
                      if (filteredTaskers.isEmpty && !_isLoading)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Helper.isDark(context)
                              ? Colors.black
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: const Center(
                            child: Text('No Taskers Found, please try again!'),
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredTaskers.length,
                        itemBuilder: (ctx, i) => TaskerWidget(
                          index: i,
                          username: filteredTaskers[i]['user']['username'],
                          availability: filteredTaskers[i]['availability'],
                          id: filteredTaskers[i]['id'],
                          displayName: filteredTaskers[i]['user']
                              ['displayName'],
                          workingCategories: filteredTaskers[i]
                              ['workingCategories'],
                          rating: filteredTaskers[i]['rating'].toString(),
                          saves: filteredTaskers[i]['saves'].toString(),
                          tasks: filteredTaskers[i]['totalTasks'].toString(),
                          profilePicture: filteredTaskers[i]['user']
                              ['profilePicture'],
                          selectedTaskers: selectedTaskers,
                          isSelected: selectedTaskers
                                  .contains(filteredTaskers[i]['id']) !=
                              false,
                          selectTaskers: selectTaskers,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedTaskers.isNotEmpty
          ? Row(
              children: [
                SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: HexColor('F2F2F3'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTaskers = [];
                      });
                    },
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: HexColor('99A4AE'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: HexColor('007FFF'),
                    ),
                    onPressed: () => Helper.showRequestModal(
                        context, selectedTaskers, _workingCategories.join('')),
                    child: Text(
                      'Request',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: HexColor('FFFFFF'),
                      ),
                    ),
                  ),
                )
              ],
            )
          : const BottomNavBarWidget(0),
    );
  }
}
