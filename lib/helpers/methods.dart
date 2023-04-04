import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/providers/chat.dart';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';

class Helper {
  Helper._();

  static bool isDark(context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? true
            : false;
    return isDarkMode;
  }

  static String timeAgo(String date) {
    var d = DateTime.parse(date);
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  static void showRequestModal(
      BuildContext context, List<dynamic> selectedTaskers, String category,
      {workingCategories = '', setSelectedTaskers = Function}) {
    final messageController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String dropdownvalue = workingCategories.toString().split(' ')[0];
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            var errorMessage = '';
            var isLoading = false;
            return StatefulBuilder(
              builder: (context, setState) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  color: Helper.isDark(context) ? Colors.black : Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      if (category.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            style: GoogleFonts.lato(fontSize: 16),
                            value: dropdownvalue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: workingCategories
                                .toString()
                                .split(' ')
                                .map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                    '${items[0].toUpperCase()}${items.substring(1)}'),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
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
                            if (messageController.text.length < 10) {
                              setState(() {
                                errorMessage =
                                    'Message should be 10 characters long';
                              });
                              return;
                            }
                            setState(() {
                              errorMessage = '';
                              isLoading = true;
                            });
                            final response =
                                await Provider.of<User>(context, listen: false)
                                    .sendNewRequest(
                              selectedTaskers,
                              messageController.text,
                              category.isEmpty ? dropdownvalue : category,
                            );
                            if (response.statusCode != 200) {
                              setState(() {
                                errorMessage = response.data['message'];
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                              setSelectedTaskers();
                              // ignore: use_build_context_synchronously
                              final navigator = Navigator.of(context);
                              Future.delayed(const Duration(seconds: 2), () {
                                navigator.pushReplacementNamed('/myrequests');
                              });
                            }
                          },
                          child: isLoading
                              ? const LoadingSpinner()
                              : const Text(
                                  'Send Request',
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void showReportModal(BuildContext context, on, by) {
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
            return StatefulBuilder(
              builder: (context, setState) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  color: Helper.isDark(context) ? Colors.black : Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complaint',
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
                            setState(() {
                              errorMessage = '';
                              isLoading = true;
                            });
                            final response =
                                await Provider.of<Chat>(context, listen: false)
                                    .reportChat(
                              on,
                              by,
                              messageController.text,
                            );
                            if (response.statusCode != 200) {
                              setState(() {
                                errorMessage = response.data['message'];
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: const Duration(
                                  seconds: 2,
                                ),
                                backgroundColor: HexColor('007FFF'),
                                content: Text(
                                  response.data['message'],
                                  style: GoogleFonts.poppins(
                                    // ignore: use_build_context_synchronously
                                    color: Helper.isDark(context)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ));
                            }
                          },
                          child: isLoading
                              ? const LoadingSpinner()
                              : const Text(
                                  'Submit Report',
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void showAddReviewModal(BuildContext context, String taskerId) {
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

  static void selectSource(Function takePicture, BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 26 / 100,
        color: Helper.isDark(context) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Image Source',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => takePicture(ImageSource.camera),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.camera,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Camera',
                          style: GoogleFonts.poppins(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () => takePicture(ImageSource.gallery),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.file_open,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Browse',
                          style: GoogleFonts.poppins(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String convertTimeFromMilliSeconds(double milliseconds) {
    double seconds = (milliseconds / 1000);
    double minutes = (seconds / 60);
    double hours = (minutes / 60);
    double days = (hours / 24);
    double weeks = (days / 7);

    if (seconds < 60) {
      return seconds < 10
          ? '0${seconds.round()} Seconds'
          : '${seconds.round()} Seconds';
    }
    if (minutes < 60) {
      return minutes < 10
          ? '0${minutes.round()} Minutes'
          : '${minutes.round()} Minutes';
    }
    if (hours < 24) {
      return hours < 10 ? '0${hours.round()} Hours' : '${hours.round()} Hours';
    }
    if (days < 7) {
      return days < 10 ? '0${days.round()} Days' : '${days.round()} Days';
    } else {
      return weeks < 10 ? '0${weeks.round()} Weeks' : '$weeks Weeks';
    }
  }
}

class BaseURL {
  static const url =
      // 'http://65.0.31.100/api';
      'http://192.168.236.47:3000/api';
  // 'http://pairtasker-prod.ap-south-1.elasticbeanstalk.com/api';

  static const socketURL =
      // 'http://65.0.31.100/';
      'http://192.168.236.47:3000';
  // 'http://pairtasker-prod.ap-south-1.elasticbeanstalk.com/';
}
