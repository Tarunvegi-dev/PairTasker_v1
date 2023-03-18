import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/screens/home_screen/tasker_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/methods.dart';
import 'dart:convert';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  var _isInit = true;
  List<dynamic> selectedTaskers = [];
  List<dynamic> loadedTaskers = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      fetchWishlist();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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

  Future<void> fetchWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('wishlist')) {
      final wishlistPref = prefs.getString('wishlist');
      List<dynamic> wishlistdata = jsonDecode(wishlistPref!) as List<dynamic>;
      setState(() {
        loadedTaskers = wishlistdata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 8 / 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Helper.isDark(context) ? Colors.white : Colors.black,
                      width: 0.2,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Text(
                  'Wishlist',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (loadedTaskers.isEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Helper.isDark(context) ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: const Center(
                    child: Text('No Taskers Found in your wishlist!'),
                  ),
                ),
              RefreshIndicator(
                onRefresh: () {
                  return fetchWishlist();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor(
                      Helper.isDark(context) ? '252B30' : '#E4ECF5',
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: loadedTaskers.length,
                    itemBuilder: (ctx, i) => TaskerWidget(
                      isWishlist: true,
                      index: i,
                      username: loadedTaskers[i]['user']['username'],
                      availability: loadedTaskers[i]['availability'],
                      workingCategories: loadedTaskers[i]['workingCategories'],
                      id: loadedTaskers[i]['id'],
                      displayName: loadedTaskers[i]['user']['displayName'],
                      rating: loadedTaskers[i]['rating'].toString(),
                      saves: loadedTaskers[i]['saves'].toString(),
                      tasks: loadedTaskers[i]['totalTasks'].toString(),
                      profilePicture: loadedTaskers[i]['user']
                          ['profilePicture'],
                      selectedTaskers: selectedTaskers,
                      isSelected:
                          selectedTaskers.contains(loadedTaskers[i]['id']) !=
                              false,
                      selectTaskers: selectTaskers,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(3),
    );
  }
}
