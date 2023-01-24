import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/theme/widgets.dart';

class Helper {
  Helper._();

  static bool isDark(context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? true
            : false;
    return isDarkMode;
  }

  static void showRequestModal(
      BuildContext context, List<dynamic> selectedTaskers) {
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
                            if (messageController.text.length < 50) {
                              setState(() {
                                errorMessage = 'Message should be 50 characters long';
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
}

class BaseURL {
  static const url =
      'http://pairtasker-test.ap-south-1.elasticbeanstalk.com/api';
}
