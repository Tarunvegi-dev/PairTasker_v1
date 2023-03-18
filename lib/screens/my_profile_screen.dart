import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/methods.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _storedImage;
  File? _croppedFile;
  var username = TextEditingController();
  var displayName = TextEditingController();
  var mobileNumber = TextEditingController();
  String gender = 'male';
  DateTime _dob = DateTime.now();

  bool _isTasker = false;
  bool _isEditing = false;
  Map<String, dynamic> _userdata = {};
  bool isLoading = false;
  var error = '';
  var _isinit = true;

  @override
  void didChangeDependencies() async {
    if (_isinit) {
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      setState(() {
        _userdata = userdata;
        username = TextEditingController(text: userdata['username'] ?? '');
        displayName =
            TextEditingController(text: userdata['displayName'] ?? '');
        mobileNumber =
            TextEditingController(text: userdata['mobileNumber'] ?? '');
        _dob = userdata['dob'] != null
            ? DateTime.parse(userdata['dob'])
            : DateTime.now();
        gender = userdata['gender'] ?? '';
        _isTasker = userdata['isTasker'] ?? false;
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  Future<void> updateUserDetails() async {
    setState(() {
      isLoading = true;
    });
    String dob = DateFormat('yyyy-MM-dd').format(_dob);
    FormData formData = FormData.fromMap(
      {
        if (_croppedFile != null)
          'image': await MultipartFile.fromFile(
            _croppedFile!.path,
          ),
        'username': username.text,
        'displayName': displayName.text,
        'mobileNumber': mobileNumber.text,
        'dob': dob,
        'gender': gender,
      },
    );
    // ignore: use_build_context_synchronously
    final response = await Provider.of<Auth>(context, listen: false)
        .updateUserDetails(formData);
    if (response.statusCode != 200) {
      setState(() {
        isLoading = false;
        error = response.data['error'];
      });
    } else {
      setState(() {
        isLoading = false;
        _isEditing = false;
      });
    }
  }

  void _selectSource() {
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
                    onTap: () => _takePicture(ImageSource.camera),
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
                    onTap: () => _takePicture(ImageSource.gallery),
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

  Future<void> _cropImage() async {
    if (_storedImage != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _storedImage!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 60,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop the image',
            toolbarColor: HexColor('007FFF'),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> _takePicture(ImageSource source) async {
    Navigator.of(context).pop();
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
    );
    // ignore: unnecessary_null_comparison
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    _cropImage();
  }

  @override
  Widget build(BuildContext context) {
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
                        'My Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: CircleAvatar(
                                    backgroundImage: _croppedFile != null
                                        ? FileImage(_croppedFile!)
                                        : _userdata['profilePicture'] != null
                                            ? NetworkImage(
                                                _userdata['profilePicture'],
                                              )
                                            : const AssetImage(
                                                'assets/images/default_user.png',
                                              ) as ImageProvider,
                                  ),
                                ),
                                if (_isEditing)
                                  InkWell(
                                    onTap: _isEditing ? _selectSource : null,
                                    child: const SizedBox(
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
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            Text(
                              _userdata['displayName'] ?? '',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _userdata['username'] != null
                                  ? '@${_userdata['username']}'
                                  : '',
                              style: GoogleFonts.lato(
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
                        TextFormField(
                          readOnly: !_isEditing,
                          controller: username,
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
                        TextFormField(
                          readOnly: !_isEditing,
                          controller: displayName,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: "Display Name",
                            hintText: "Enter your nick name",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                "assets/images/icons/mail.svg",
                              ),
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
                        TextFormField(
                          readOnly: !_isEditing,
                          controller: mobileNumber,
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
                        TextFormField(
                          readOnly: !_isEditing,
                          controller: TextEditingController(
                            text: DateFormat.yMMMMd().format(_dob),
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
                              onTap: !_isEditing
                                  ? null
                                  : () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: _dob,
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2050),
                                      );
                                      if (pickedDate != null &&
                                          pickedDate != _dob) {
                                        setState(() {
                                          _dob = pickedDate;
                                        });
                                      }
                                    },
                              child: Icon(
                                Icons.calendar_today,
                                color: HexColor('99A4AE'),
                                size: 22,
                              ),
                            ),
                          ),
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
                                    "assets/images/icons/gender.svg",
                                  ),
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
                                      onChanged: _isEditing
                                          ? (value) {
                                              setState(
                                                () => gender = value.toString(),
                                              );
                                            }
                                          : null,
                                    ),
                                    Text(
                                      'Male',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
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
                                      onChanged: _isEditing
                                          ? (value) {
                                              setState(
                                                () => gender = value.toString(),
                                              );
                                            }
                                          : null,
                                    ),
                                    Text(
                                      'Female',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
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
                                      onChanged: _isEditing
                                          ? (value) {
                                              setState(
                                                () => gender = value.toString(),
                                              );
                                            }
                                          : null,
                                    ),
                                    Text(
                                      'Others',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
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
                        if (!_isTasker)
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/taskerform'),
                            child: Text(
                              'Create tasker account',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: HexColor('007FFF'),
                              ),
                            ),
                          ),
                        if (_isTasker)
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Delete tasker account',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: HexColor('FF033E'),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  backgroundColor: _isEditing
                      ? HexColor('007FFF')
                      : Helper.isDark(context)
                          ? HexColor('252B30')
                          : HexColor('DEE0E0'),
                  elevation: 0,
                ),
                onPressed: isLoading
                    ? null
                    : _isEditing
                        ? updateUserDetails
                        : () => setState(() {
                              _isEditing = true;
                            }),
                child: isLoading
                    ? const LoadingSpinner()
                    : Text(
                        _isEditing ? 'Save' : 'Edit',
                        style: GoogleFonts.lato(
                          color: _isEditing ? Colors.white : HexColor('007FFF'),
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
