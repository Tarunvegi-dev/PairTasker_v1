import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/screens/tasker_profile/review_widget.dart';
import 'package:provider/provider.dart';
import '../../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pairtasker/theme/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TaskerProfile extends StatefulWidget {
  final id;

  const TaskerProfile({this.id, super.key});

  @override
  State<TaskerProfile> createState() => _TaskerProfileState();
}

class _TaskerProfileState extends State<TaskerProfile> {
  var _isInit = true;
  String username = '';
  String displayName = '';
  String rating = '';
  String totalTasks = '';
  String profilePicture = '';
  bool isWishlisted = false;
  int availability = 100;
  List<dynamic> reviewsdata = [];
  List<dynamic> workingCategories = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final response = await Provider.of<Tasker>(context, listen: false)
          .getTaskerDetails(widget.id);
      final reviews =
          // ignore: use_build_context_synchronously
          await Provider.of<Tasker>(context, listen: false)
              .getTaskerReviews(widget.id);
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      var wishlist = userdata['wishlist'] ?? [];
      setState(() {
        isWishlisted = wishlist.contains(widget.id) != false;
      });
      if (response.data['status'] == true) {
        var taskerData = response.data['data'];
        setState(() {
          reviewsdata = reviews;
          availability = taskerData['availability'];
          workingCategories = taskerData['workingCategories'];
          profilePicture = taskerData['user']['profilePicture'] ?? '';
          username = taskerData['user']['username'] ?? '';
          displayName = taskerData['user']['displayName'] ?? '';
          rating = taskerData['rating'].toString();
          totalTasks = taskerData['totalTasks'].toString();
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> handleWishlist() async {
    final response = await Provider.of<User>(context, listen: false)
        .manageWishlist(widget.id, !isWishlisted);
    if (response.statusCode == 200) {
      setState(() {
        isWishlisted = !isWishlisted;
      });
    }
  }

  void showAddReviewModal(BuildContext context, String taskerId) {
    final messageController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                var errorMessage = '';
                var isLoading = false;
                double rating = 2.5;
                return StatefulBuilder(
                  builder: (context, updateState) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar(
                            initialRating: rating,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: HexColor('FFC72C'),
                              ),
                              half: Icon(
                                Icons.star_half,
                                color: HexColor('FFC72C'),
                              ),
                              empty: const Icon(Icons.star_border),
                            ),
                            onRatingUpdate: (r) {
                              updateState(() {
                                rating = r;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Message',
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: messageController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  color: Helper.isDark(context)
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              hintText: 'Enter your message here..',
                            ),
                          ),
                          if (errorMessage != '')
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                ErrorMessage(errorMessage)
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor: HexColor('007FFF'),
                              ),
                              onPressed: () async {
                                if (messageController.text.isEmpty) {
                                  updateState(() {
                                    errorMessage =
                                        'Message should not be empty';
                                  });
                                  return;
                                }
                                updateState(() {
                                  errorMessage = '';
                                  isLoading = true;
                                });
                                final response = await Provider.of<User>(
                                  context,
                                  listen: false,
                                ).addReview(
                                  taskerId,
                                  messageController.text,
                                  rating,
                                );
                                if (response.statusCode != 200) {
                                  updateState(() {
                                    errorMessage = response.data['message'];
                                    isLoading = false;
                                  });
                                } else {
                                  updateState(() {
                                    isLoading = false;
                                  });
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  setState(() {
                                    reviewsdata.insert(
                                      0,
                                      response.data['data'],
                                    );
                                  });
                                }
                              },
                              child: isLoading
                                  ? const LoadingSpinner()
                                  : const Text(
                                      'Submit',
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 34,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  Text(
                    'ACTIVE',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor('32DE84'),
                    ),
                  ),
                  InkWell(
                    onTap: handleWishlist,
                    child: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: HexColor(isWishlisted ? 'FF033E' : 'FFFFFF'),
                      size: 34,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Helper.isDark(context)
                      ? HexColor('252B30')
                      : HexColor('DEE0E0'),
                ),
                child: Column(
                  children: [
                    Container(
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
                      padding: const EdgeInsets.only(
                        top: 28,
                        left: 26,
                        right: 20,
                        bottom: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 37,
                                    width: 37,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: profilePicture != ''
                                          ? NetworkImage(
                                              profilePicture,
                                            )
                                          : const AssetImage(
                                              'assets/images/default_user.png',
                                            ) as ImageProvider,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '@$username',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: HexColor('#AAABAB'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    backgroundColor: HexColor('007FFF'),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 25,
                                    ),
                                  ),
                                  onPressed: () => Helper.showRequestModal(
                                      context, [widget.id], '',
                                      workingCategories:
                                          workingCategories.join(' ')),
                                  child: Text(
                                    'REQUEST',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
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
                                    rating,
                                    style: GoogleFonts.lato(
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
                                    totalTasks,
                                    style: GoogleFonts.lato(
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
                                    availability < 33.3
                                        ? Icons.wifi_1_bar
                                        : availability > 33.33 &&
                                                availability < 66.66
                                            ? Icons.wifi_2_bar
                                            : Icons.wifi,
                                    color: availability < 33.3
                                        ? HexColor('FF033E')
                                        : availability > 33.33 &&
                                                availability < 66.66
                                            ? HexColor('FFC72C')
                                            : HexColor('#00CE15'),
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '$availability%',
                                    style: GoogleFonts.lato(
                                      color: HexColor('#AAABAB'),
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          Text(
                            'Working Categories',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                              color: HexColor('99A4AE'),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            spacing: 5.0,
                            runSpacing: 15.0,
                            children: workingCategories
                                .map((category) => Container(
                                      width: 100,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: Helper.isDark(context)
                                            ? const Color.fromRGBO(
                                                255,
                                                255,
                                                255,
                                                0.1,
                                              )
                                            : const Color.fromRGBO(
                                                0,
                                                0,
                                                0,
                                                0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          category,
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Text(
                            'Reviews',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                              color: HexColor('99A4AE'),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (reviewsdata.isEmpty)
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Helper.isDark(context)
                              ? Colors.black
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: const Center(
                            child: Text('NO REVIEWS YET!'),
                          ),
                        ),
                      ),
                    if (reviewsdata.isNotEmpty)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 4,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: reviewsdata.length,
                            itemBuilder: (BuildContext context, int i) =>
                                Review(
                              profilePicture: reviewsdata[i]['user']
                                  ['profilePicture'],
                              displayName: reviewsdata[i]['user']
                                  ['displayName'],
                              username: reviewsdata[i]['user']['username'],
                              message: reviewsdata[i]['message'],
                              createdAt:
                                  Helper.timeAgo(reviewsdata[i]['createdAt']),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => showAddReviewModal(context, widget.id),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          'Give Feedback',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
