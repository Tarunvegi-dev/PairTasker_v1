import 'package:flutter/material.dart';
import 'package:getwidget/components/radio/gf_radio.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String gender = 'male';
  DateTime _currentDate = DateTime.now();
  bool _taskerStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 8 / 100,
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
                        'My Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HexColor('1A1E1F'),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.more_vert,
                    size: 28,
                    color: HexColor('99A4AE'),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Stack(
                              children: const [
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      'https://icustomercareinformation.in/wp-content/uploads/2021/05/virat-kohli.jpg',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(0, 0, 0, 0.4),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            const Text(
                              'Will Smith',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '@willsmith143',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor('AAABAB'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 23, 20, 0),
                    child: Column(
                      children: [
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
                              child: SvgPicture.asset(
                                  "assets/images/icons/mail.svg"),
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
                                borderSide:
                                    BorderSide(color: HexColor("#007FFF")),
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
                                  SvgPicture.asset(
                                      "assets/images/icons/gender.svg"),
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
                            const SizedBox(
                              height: 10,
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
                                        setState(
                                            () => gender = value.toString());
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
                                        setState(
                                            () => gender = value.toString());
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
                                        setState(
                                            () => gender = value.toString());
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
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor('007FFF'),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Want to be a Tasker?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Switch(
                                    value: _taskerStatus,
                                    activeColor: Colors.white,
                                    onChanged: (bool position) {
                                      setState(
                                          () => _taskerStatus = !_taskerStatus);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: HexColor('99A4AE'),
                                width: 0.5,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            bottom: 18,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Working Categories',
                                style: TextStyle(
                                  color: HexColor('6F7273'),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.add,
                                size: 26,
                                color: HexColor('007FFF'),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: HexColor('99A4AE'),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                top: 12,
                                left: 15,
                                right: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Mechanic',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor('007FFF'),
                                        width: 2.3,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.5),
                                      child: Container(
                                        height: 6,
                                        width: 6,
                                        color: HexColor('007FFF'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: HexColor('99A4AE'),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                top: 12,
                                left: 15,
                                right: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Delivery Boy',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor('007FFF'),
                                        width: 2.3,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.5),
                                      child: Container(
                                        height: 6,
                                        width: 6,
                                        color: HexColor('007FFF'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: HexColor('99A4AE'),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                top: 12,
                                left: 15,
                                right: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Camera Man',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor('99A4AE'),
                                        width: 2.3,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 41,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                  backgroundColor: HexColor('E4ECF5'),
                  elevation: 0,
                ),
                onPressed: () {},
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: HexColor('007FFF'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
