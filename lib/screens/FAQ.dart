import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../helpers/methods.dart';

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 8 / 100,
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
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                        'Frequently Asked Questions',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'For User',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: HexColor('007fff'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to create a new tasker account?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'If you are already a user and want to create a tasker account, go to the home screen and click on the menu icon in the top left corner. In the side menu click on Profile and then you will see an option to ‘ create tasker account ’',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to send a new request to taskers?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Note: You can send a request to multiple taskers',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'On the home screen, you will be able to see the list of taskers available in your region. Long press on the tasker profile icon or anywhere on the card will let you select the tasker. Now you are in select mode and you can select multiple taskers by clicking on their cards. After selecting the taskers at the bottom of the screen you can see options for cancel and request. After clicking on the request you will be asked to write a message. Fill the message field with your task and click on send request.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to see all my requests?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'In the home screen, you will see the navigation at the bottom of the screen click on the request icon present in the middle of the nav items and you can see your requests.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to contact the tasker that I have requested?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'When you make a new request to the list of taskers. The taskers receive a notification to accept or reject your Request. If a Tasker accepts your request then you can contact him on the Chat screen. You can chat with him by clicking on the request in the My Request screen',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How the task is confirmed?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    ' After dealing is done between the tasker and the user. Tasker can send a request confirmation to the user on the Chat Screen. And then you will have to choose an option to confirm or to cancel.  By clicking on Confirm you can confirm the order.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Note: After the order is Confirmed User and Tasker are blocked to send messages.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to withdraw a request?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'In the My requests Screen you will see your requests. In your active requests click on any of the requests and you will be redirected to the chat screen. Click on the 3 dots at the top right corner of the screen. You will see an option to withdraw the request.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Note: The user cannot  WithDraw the request after the task is confirmed.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to report tasker?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'In the Chat Screen, you will be able to report the tasker by clicking on the 3 dots in the top right corner of the screen. And you will see an option to Report abuse.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'For Tasker',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: HexColor('007fff'),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to register as Tasker?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'When you installed the app and opened it for the first time you will be prompted to create an account.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'After your email verification, you will be redirected to update “User Info” where you can change your profile.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'At the bottom of the page, there is a button to Continue as Tasker click on it, and you will be redirected to choose some categories showing up there and continue as Tasker.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '(Or)',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  Text(
                    'If you are already a user and want to create a tasker account, go to the home screen cand click on the menu icon in the top left corner. In the side menu click on Profile and then you will see an option to ‘ create tasker account ’',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How do I new get tasks?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'If you are a tasker you should turn on Tasker Mode in the My Profile screen, Then you will be visible to users. When the user selects you and requests you will get a notification to accept or reject the task.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to contact the user after accepting the task?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'When you accept a new task. In the My Tasks section, you will see all your tasks. you can contact him on the Chat screen. You can chat with him by clicking on the task in the My Tasks screen',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to send a task confirmation request?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'After the tasker and user done dealing and are clear about the task. Tasker can send the request to confirm to the user by clicking on the 3 dots menu icon in the bottom right corner of the Chat Screen. If the user accepts your request then the Task is confirmed',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to terminate from the task?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'If the dealing is not so healthy between the user and tasker, the tasker is allowed to terminate the task. By clicking on the 3 dots on the top right corner of the Chat Screen tasker can be terminated.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to report users?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'In the Chat Screen, you will be able to report the user by clicking on the 3 dots in the top right corner of the screen. And you will see the option to Report abuse.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
