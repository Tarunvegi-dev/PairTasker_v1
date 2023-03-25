import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';

class Review extends StatelessWidget {
  final profilePicture;
  final displayName;
  final username;
  final createdAt;
  final message;
  const Review(
      {this.profilePicture,
      this.displayName,
      this.username,
      this.createdAt,
      this.message,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Helper.isDark(context) ? Colors.black : Colors.white,
          padding: const EdgeInsets.only(
            left: 20,
            right: 30,
            top: 5,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        margin: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: profilePicture == null
                              ? const AssetImage(
                                  'assets/images/default_user.png',
                                )
                              : NetworkImage(
                                  profilePicture,
                                ) as ImageProvider,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '@$username',
                            style: GoogleFonts.lato(
                              fontSize: 10,
                              color: HexColor('#AAABAB'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    createdAt,
                    style: GoogleFonts.lato(
                      color: HexColor('99A4AE'),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lato(
                    color: HexColor('99A4AE'),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color:
              Helper.isDark(context) ? HexColor('252B30') : HexColor('E4ECF5'),
          height: 4,
        )
      ],
    );
  }
}
