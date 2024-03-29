import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/screens/home_screen/drawer.dart';
import 'package:pairtasker/screens/home_screen/tasker_widget.dart';
import 'package:pairtasker/screens/screens.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth.dart';
import '../../helpers/methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> key = GlobalKey();
  List<dynamic> kOptions = [];
  List<dynamic> _workingCategories = [];
  List<dynamic> filteredTaskers = [];
  var _isInit = true;
  var _isLoading = false;
  String sortCategory = 'rating';
  String address = '';
  int page = 1;
  bool loading = false;
  int totalTaskers = 0;

  @override
  void didChangeDependencies() async {
    final prefs = await SharedPreferences.getInstance();
    final a = prefs.getString('address');
    // ignore: use_build_context_synchronously
    final response = await Provider.of<Auth>(context, listen: false)
        .fetchWorkingCategories();
    final workingCategories = response.data['data'] as List<dynamic>;
    if (response.statusCode == 200) {
      var options = [];
      workingCategories.forEach((w) => options.add(w['name']));
      setState(() {
        kOptions = options;
      });
    }
    if (prefs.containsKey('workingCategories')) {
      final workingCategoriesPref = prefs.getString('workingCategories');
      List<dynamic> workingCategoriesData =
          jsonDecode(workingCategoriesPref!) as List<dynamic>;
      setState(() {
        _workingCategories = workingCategoriesData;
        kOptions.remove(_workingCategories[0]);
        kOptions.insert(0, _workingCategories[0]);
      });
    } else {
      setState(() {
        _workingCategories.add(kOptions[0]);
      });
    }
    setState(() {
      address = a.toString();
    });
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
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
    final response = await Provider.of<User>(context, listen: false).getTaskers(
        sortBy: sortCategory,
        sort: true,
        search: true,
        keyword: '',
        workingCategories: _workingCategories.join(' '));
    setState(() {
      filteredTaskers = response['taskers'];
    });
  }

  Future<void> loadMoreTaskers() async {
    setState(() {
      page += 1;
      loading = true;
    });
    final response = await Provider.of<User>(context, listen: false).getTaskers(
      page: page.toString(),
      search: true,
      workingCategories: _workingCategories.join(' '),
      keyword: '',
    );
    setState(() {
      filteredTaskers.addAll(response['taskers']);
      loading = false;
    });
  }

  Future<void> searchTaskers() async {
    final response = await Provider.of<User>(context, listen: false).getTaskers(
      search: true,
      keyword: '',
      workingCategories: _workingCategories.join(" "),
    );
    setState(() {
      filteredTaskers = response['taskers'];
      totalTaskers = int.parse(response['totalTaskers'] ?? 0);
      page = 1;
    });
  }

  void manageWorkingCategories(category) async {
    setState(() {
      _workingCategories.removeRange(0, _workingCategories.length);
      _workingCategories.add(category.toString().trim());
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('workingCategories');
    prefs.setString('workingCategories', jsonEncode(_workingCategories));
    setState(() {
      sortCategory = 'rating';
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
                style: GoogleFonts.nunito(
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
                style: GoogleFonts.nunito(
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
                style: GoogleFonts.nunito(
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
                style: GoogleFonts.nunito(
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

  void setSelectedTaskersEmpty() {
    setState(() {
      selectedTaskers = [];
    });
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
                              address != 'null' ? address : 'Andhra Pradesh',
                              style: GoogleFonts.nunito(
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
                              child: Icon(
                                Icons.sort_sharp,
                                color: HexColor('AAABAB'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: searchTaskers,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor(
                            Helper.isDark(context) ? '252B30' : '#E4ECF5',
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: kOptions.length,
                          itemBuilder: (context, i) => InkWell(
                            onTap: () => manageWorkingCategories(kOptions[i]),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: _workingCategories.contains(kOptions[i])
                                    ? HexColor('007FFF')
                                    : Helper.isDark(context)
                                        ? const Color.fromRGBO(
                                            255, 255, 255, 0.1)
                                        : const Color.fromRGBO(0, 0, 0, 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  kOptions[i],
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    color:
                                        _workingCategories.contains(kOptions[i])
                                            ? Colors.white
                                            : Helper.isDark(context)
                                                ? Colors.white
                                                : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                      NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              totalTaskers > 15 &&
                              filteredTaskers.length < totalTaskers) {
                            loadMoreTaskers();
                          }
                          return false;
                        },
                        child: Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredTaskers.length,
                            itemBuilder: (ctx, i) => TaskerWidget(
                              index: i,
                              isVerified:
                                  filteredTaskers[i]['verified'] ?? false,
                              username: filteredTaskers[i]['user']['username'],
                              availability: filteredTaskers[i]['metrics']
                                  ['availabilityRatio'],
                              id: filteredTaskers[i]['id'],
                              displayName: filteredTaskers[i]['user']
                                  ['displayName'],
                              workingCategories: filteredTaskers[i]
                                  ['workingCategories'],
                              rating: filteredTaskers[i]['rating'].toString(),
                              saves: filteredTaskers[i]['saves'].toString(),
                              tasks: filteredTaskers[i]['completedTasks']
                                  .toString(),
                              profilePicture: filteredTaskers[i]['user']
                                  ['profilePicture'],
                              selectedTaskers: selectedTaskers,
                              isSelected: selectedTaskers
                                      .contains(filteredTaskers[i]['id']) !=
                                  false,
                              selectTaskers: selectTaskers,
                            ),
                          ),
                        ),
                      ),
                      if (loading)
                        Column(
                          children: const [
                            LoadingSpinner(),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        )
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
                    onPressed: setSelectedTaskersEmpty,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.nunito(
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
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SendRequest(
                          selectedTaskers: selectedTaskers,
                          category: _workingCategories.join(''),
                          setSelectedTaskers: setSelectedTaskersEmpty,
                        ),
                      ),
                    ),
                    child: Text(
                      'Request',
                      style: GoogleFonts.nunito(
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
