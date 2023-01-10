import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pairtasker/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helpers/methods.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:dio/dio.dart';
import '../theme/widgets.dart';
import 'package:image_cropper/image_cropper.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String gender = 'male';
  DateTime _currentDate = DateTime.now();
  bool isChecked = false;
  String token = '';
  // ignore: unused_field, avoid_init_to_null
  File? _storedImage;
  File? _croppedFile;

  final username = TextEditingController();
  final displayName = TextEditingController();
  final mobileNumber = TextEditingController();
  bool isLoading = false;
  var error = '';

  String getToken() {
    final token = Provider.of<Auth>(context, listen: false).token;
    return token;
  }

  @override
  void initState() {
    setState(() {
      token = getToken();
    });
    super.initState();
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

  Future<void> updateUserDetails() async {
    setState(() {
      error = '';
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    String dob = DateFormat('yyyy-MM-dd').format(_currentDate);
    FormData formData = FormData.fromMap(
      {
        'image': _croppedFile != null
            ? await MultipartFile.fromFile(
                _croppedFile!.path,
              )
            : null,
        'username': username.text.trim(),
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
        error = response.data['error'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushReplacementNamed(isChecked ? '/taskerform' : '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UserInfo',
                  style: PairTaskerTheme.title2,
                ),
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: InkWell(
                              onTap: _selectSource,
                              child: CircleAvatar(
                                // ignore: unnecessary_null_comparison
                                backgroundImage: _croppedFile != null
                                    ? FileImage(_croppedFile!)
                                    : const AssetImage(
                                        "assets/images/user_profile.png",
                                      ) as ImageProvider,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: username,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This Field is required';
                            }
                            return null;
                          },
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
                          controller: displayName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This Field is required';
                            }
                            return null;
                          },
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
                        TextFormField(
                          controller: mobileNumber,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 10) {
                              return 'Enter Valid Mobile Number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This Field is required';
                            }
                            return null;
                          },
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
                              },
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
                                      onChanged: (value) {
                                        setState(
                                            () => gender = value.toString());
                                      },
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
                                      onChanged: (value) {
                                        setState(
                                            () => gender = value.toString());
                                      },
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
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: HexColor(Helper.isDark(context)
                                    ? "252B30"
                                    : "E4ECF5"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Tasker is person who is ready to work for users and get hired. Tasker can work in their respective working categories, in their flexible working hours. Tasker can communicate with the user and charge users for task. ",
                                  style: GoogleFonts.lato(letterSpacing: 0.7),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        activeColor: HexColor('#007FFF'),
                                        value: isChecked,
                                        onChanged: (bool? value) => {
                                          setState(() {
                                            isChecked = value!;
                                          })
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Policy and Terms for Tasker',
                                    style: GoogleFonts.nunito(
                                      color: HexColor('#007FFF'),
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (error != '')
                          Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ErrorMessage(error)
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 90 / 100,
                          height: 43,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : updateUserDetails,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              side: isChecked
                                  ? null
                                  : BorderSide(
                                      color: HexColor('99A4AE'),
                                      width: 0.5,
                                    ),
                              backgroundColor: isChecked
                                  ? HexColor('#007FFF')
                                  : Helper.isDark(context)
                                      ? Colors.black
                                      : Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            child: isLoading
                                ? const LoadingSpinner()
                                : Text(
                                    isChecked
                                        ? 'Continue as Tasker'
                                        : 'Continue',
                                    style: isChecked
                                        ? PairTaskerTheme.buttonText
                                        : GoogleFonts.lato(
                                            color: HexColor('007FFF'),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
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
