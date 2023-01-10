import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/screens/home_screen/Tasker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/theme/widgets.dart';
import '../helpers/methods.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<User>(context).getWishlist().then((_) {
        setState(() {
          _isLoading = false;
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

  Future<void> _refreshWishlist() async {
    await Provider.of<User>(context, listen: false).getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final taskersdata = Provider.of<User>(context);
    final loadedTaskers = taskersdata.wishlist;
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
            Container(
              decoration: BoxDecoration(
                color:
                    HexColor(Helper.isDark(context) ? '252B30' : '#E4ECF5'),
              ),
              child: RefreshIndicator(
                onRefresh: _refreshWishlist,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: loadedTaskers.length,
                  itemBuilder: (ctx, i) => TaskerWidget(
                    index: i,
                    username: loadedTaskers[i]['user']['username'],
                    id: loadedTaskers[i]['id'],
                    displayName: loadedTaskers[i]['user']['displayName'],
                    rating: loadedTaskers[i]['rating'].toString(),
                    saves: loadedTaskers[i]['saves'].toString(),
                    tasks: loadedTaskers[i]['totalTasks'].toString(),
                    profilePicture:
                        loadedTaskers[i]['user']['profilePicture'].toString(),
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
      bottomNavigationBar: const BottomNavBarWidget(1),
    );
  }
}
