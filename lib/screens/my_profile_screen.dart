import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/screens/select_community/community_widget.dart';
import 'package:pairtasker/screens/select_community/select_community_screen.dart';
import 'package:pairtasker/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/methods.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

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
  String email = '';

  bool _isTasker = false;
  bool _isEditing = false;
  Map<String, dynamic> _userdata = {};
  bool isLoading = false;
  var error = '';
  var _isinit = true;

  File? myFile;

  Future<void> convertUrlToFile(profilePicture) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = path.join(dir.path, path.basename(profilePicture));
    setState(() {
      myFile = File(pathName);
    });
  }

  @override
  void didChangeDependencies() async {
    if (_isinit) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
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
        email = userdata['email'];
      });
      convertUrlToFile(userdata['profilePicture'] ?? '');
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
        if (_userdata['username'] != username.text.replaceAll(' ', ''))
          'username': username.text,
        if (_userdata['displayName'] != displayName.text)
          'displayName': displayName.text,
        if (_userdata['mobileNumber'] != mobileNumber.text)
          'mobileNumber': mobileNumber.text,
        if (_userdata['dob'] != dob) 'dob': dob,
        if (_userdata['gender'] != gender) 'gender': gender,
      },
    );
    // ignore: use_build_context_synchronously
    final response = await Provider.of<Auth>(context, listen: false)
        .updateUserDetails(formData, context);
    if (response.statusCode != 200) {
      setState(() {
        isLoading = false;
        error = response.data['message'] ??
            'Something went wrong! please, try again.';
      });
    } else {
      setState(() {
        isLoading = false;
        _isEditing = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: HexColor('007FFF'),
        duration: const Duration(
          seconds: 2,
        ),
        content: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Icon(
                Icons.done,
                color: HexColor('007FFF'),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Profile data updated successfully',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
      ));
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

  void deleteTaskerAccount() async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        showCancelBtn: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textTextStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: HexColor('FF0338'),
        ),
        title: 'Are you sure want to delete your tasker account?',
        text:
            'confirming this action will make you lose your tasker profile, your tasks, every data related to your tasker account.',
        onConfirmBtnTap: () async {
          final response = await Provider.of<Auth>(
            context,
            listen: false,
          ).deleteTaskerAccount();
          if (response.statusCode == 200) {
            _isTasker = false;
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamed('/home');
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(
                seconds: 2,
              ),
              backgroundColor: HexColor('FF033E'),
              content: Text(
                response.data['message'],
                style: GoogleFonts.poppins(
                  color:
                      // ignore: use_build_context_synchronously
                      Helper.isDark(context) ? Colors.white : Colors.black,
                ),
              ),
            ));
          }
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
                  InkWell(
                    onTap: isLoading
                        ? null
                        : _isEditing
                            ? updateUserDetails
                            : () => setState(() {
                                  _isEditing = true;
                                }),
                    child: isLoading
                        ? const LoadingSpinner()
                        : _isEditing
                            ? Icon(
                                Icons.done,
                                size: 28,
                                color: HexColor('007FFF'),
                              )
                            : Helper.isDark(context)
                                ? Image.asset(
                                    'assets/images/icons/edit_light.png',
                                    height: 18,
                                  )
                                : Image.asset(
                                    'assets/images/icons/edit.png',
                                    height: 18,
                                  ),
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
                                            ? NetworkToFileImage(
                                                url:
                                                    _userdata['profilePicture'],
                                                file: myFile,
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
                              email,
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
                          height: 15,
                        ),
                        if (_userdata['communityId'] != null)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          color: HexColor('AAABAB'),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 5,
                                          ),
                                          child: Text(
                                            "Community",
                                            style: PairTaskerTheme.inputLabel,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            const SelectCommunityScreen(
                                              isUpdating: true,
                                            )),
                                      ),
                                    ),
                                    child: Text(
                                      'change',
                                      style: GoogleFonts.lato(
                                        color: HexColor('007FFF'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ApartmentWidget(
                                isSelected: false,
                                name: _userdata['community']['name'],
                                imageUrl: _userdata['community']['picture'],
                                address: _userdata['community']['address']
                                    ['line'],
                                city:
                                    '${_userdata['community']['address']['city']}, ${_userdata['community']['address']['state']} ${_userdata['community']['address']['pincode']}',
                              ),
                            ],
                          ),
                        if (error.isNotEmpty) ErrorMessage(error),
                        const SizedBox(
                          height: 10,
                        ),
                        if (_userdata['role'] == 'user')
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
                        if (_userdata['role'] == 'tasker')
                          TextButton(
                            onPressed: deleteTaskerAccount,
                            child: Text(
                              'Delete tasker account',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: HexColor('FF033E'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
