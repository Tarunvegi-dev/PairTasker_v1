import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:pairtasker/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  String gender = 'male';
  DateTime _currentDate = DateTime.now();
  bool _taskerStatus = true;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: ListView(
              children: <Widget>[
                Text(
                  "User Info",
                  style: PairTaskerTheme.title2,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "Username",
                    hintText: "Create a new username",
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: HexColor("99A4AE"),
                      size: 22,
                    ),
                    labelStyle: PairTaskerTheme.inputLabel,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#007FFF"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "Display Name",
                    hintText: "Enter your nick name",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset("assets/images/icons/mail.svg"),
                    ),
                    labelStyle: PairTaskerTheme.inputLabel,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#007FFF"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "Mobile Number",
                    hintText: "Enter your mobile number",
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 22,
                      color: HexColor('99A4AE'),
                    ),
                    labelStyle: PairTaskerTheme.inputLabel,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#007FFF"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat.yMMMMd().format(_currentDate),
                  ),
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: "Date of Birth",
                      hintText: "Pick date from the calender",
                      labelStyle: PairTaskerTheme.inputLabel,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#007FFF")),
                      ),
                      prefixIcon: InkWell(
                          child: Icon(
                            Icons.calendar_today,
                            color: HexColor('99A4AE'),
                            size: 22,
                          ),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _currentDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050),
                            );
                            if (pickedDate != null &&
                                pickedDate != _currentDate) {
                              setState(() {
                                _currentDate = pickedDate;
                              });
                            }
                          })),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/icons/gender.svg"),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Text(
                              "Gender",
                              style: PairTaskerTheme.inputLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio(
                              toggleable: false,
                              value: 'male',
                              activeColor: HexColor("#007FFF"),
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() => gender = value.toString());
                                // print(value.toString());
                              },
                            ),
                            const Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              toggleable: false,
                              value: 'female',
                              activeColor: HexColor("#007FFF"),
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() => gender = value.toString());
                              },
                            ),
                            const Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              toggleable: false,
                              value: 'others',
                              activeColor: HexColor("#007FFF"),
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() => gender = value.toString());
                              },
                            ),
                            const Text(
                              'Others',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Want to be a tasker?",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color.fromRGBO(0, 127, 2555, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Switch(
                            value: _taskerStatus,
                            activeColor: HexColor("#007FFF"),
                            onChanged: (bool position) {
                              setState(() => _taskerStatus = !_taskerStatus);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: HexColor("#E4ECF5"),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "You can get benfits of making money by doing tasks. You will get tasks from our app users nearby. You can charge the users according to the situations, distance and profit.",
                          style: TextStyle(letterSpacing: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 90 / 100,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#007FFF'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    child: Text(
                      'Proceed',
                      style: PairTaskerTheme.buttonText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
