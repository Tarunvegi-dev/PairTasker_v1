import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'dart:io';

import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  final Image;
  const ViewImage({this.Image, super.key});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  final msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: HexColor('AAABAB'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: PhotoView(
                  minScale: 0.5,
                  maxScale: 0.6,
                  imageProvider: NetworkImage(
                    widget.Image,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
