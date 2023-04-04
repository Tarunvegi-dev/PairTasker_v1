import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';

class SendRequest extends StatefulWidget {
  final selectedTaskers;
  final category;
  final workingCategories;
  final setSelectedTaskers;

  const SendRequest({
    this.selectedTaskers,
    this.category = '',
    this.workingCategories = '',
    this.setSelectedTaskers = Function,
    super.key,
  });

  @override
  State<SendRequest> createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  final messageController = TextEditingController();
  var errorMessage = '';
  var isLoading = false;
  String dropdownvalue = '';
  File? _storedImage;
  String imageUrl = '';

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
  }

  void sendRequest() async {
    if (messageController.text.length < 10) {
      setState(() {
        errorMessage = 'Message should be 10 characters long';
      });
      return;
    }
    setState(() {
      errorMessage = '';
      isLoading = true;
    });
    if (_storedImage != null) {
      final res = await Provider.of<Auth>(context, listen: false)
          .uploadImage(_storedImage!);
      setState(() {
        imageUrl = res;
      });
    }
    final response =
        // ignore: use_build_context_synchronously
        await Provider.of<User>(context, listen: false).sendNewRequest(
      widget.selectedTaskers,
      messageController.text,
      widget.category.isEmpty ? dropdownvalue : widget.category,
      imageUrl: imageUrl,
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
      widget.setSelectedTaskers();
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);
      Future.delayed(const Duration(seconds: 2), () {
        navigator.pushReplacementNamed('/myrequests');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Helper.isDark(context) ? Colors.black : Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send New Request',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                      hintText: 'Your message...',
                      hintStyle: GoogleFonts.lato(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Optional",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _storedImage != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.file(
                              _storedImage!,
                              height: 200,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _storedImage = null;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    20 /
                                    100,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: HexColor(
                                    Helper.isDark(context)
                                        ? '252B30'
                                        : '#E4ECF5',
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: HexColor('FF033E'),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'Clear',
                                      style: GoogleFonts.lato(
                                        color: HexColor('FF033E'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      : DottedBorder(
                          dashPattern: const [
                            6,
                            4,
                          ],
                          color: HexColor('007FFF'),
                          strokeWidth: 0.5,
                          child: InkWell(
                            onTap: () => Helper.selectSource(
                              _takePicture,
                              context,
                            ),
                            child: SizedBox(
                              height: 200,
                              child: Center(
                                child: SvgPicture.asset(
                                    'assets/images/image_upload.svg'),
                              ),
                            ),
                          ),
                        ),
                  if (widget.category.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        style: GoogleFonts.lato(fontSize: 16),
                        value: dropdownvalue == ''
                            ? widget.workingCategories.toString().split(' ')[0]
                            : dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: widget.workingCategories
                            .toString()
                            .split(' ')
                            .map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: GoogleFonts.lato(
                                color: Helper.isDark(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width * 50 / 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: HexColor('F2F2F3'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: HexColor('99A4AE'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width * 50 / 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: HexColor('007FFF'),
              ),
              onPressed: sendRequest,
              child: isLoading
                  ? const LoadingSpinner()
                  : const Text(
                      'Request',
                    ),
            ),
          )
        ],
      ),
    );
  }
}
