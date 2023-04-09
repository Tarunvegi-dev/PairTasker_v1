import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';

class RatioWidget extends StatelessWidget {
  final title;
  final icon;
  final ratio;
  final percentage;
  final description;
  final color;
  final time;

  const RatioWidget({
    this.time,
    this.title,
    this.icon,
    this.ratio,
    this.percentage,
    this.description,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Helper.isDark(context) ? Colors.black : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/$icon.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        title,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: icon == 'time' ? 10 : 5,
                  ),
                  if (icon != 'time')
                    Text(
                      description,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: HexColor('AAABAB'),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sum of all task completion time',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: HexColor('AAABAB'),
                          ),
                        ),
                        Text(
                          'by Completed Tasks',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: HexColor('AAABAB'),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (icon != 'time')
                    Column(
                      children: [
                        Text(
                          ratio,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                ],
              ),
              if (icon != 'time')
                Text(
                  '$percentage%',
                  style: GoogleFonts.lato(
                    fontSize: 42,
                    color: HexColor(color),
                    fontWeight: FontWeight.w700,
                  ),
                )
              else
                Row(
                  children: [
                    Text(
                      '$time'.substring(0, 3),
                      style: GoogleFonts.lato(
                        fontSize: 42,
                        color: HexColor(color),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Text(
                        '$time'.substring(3),
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: HexColor('AAABAB'),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
        Container(
          height: 3,
          width: MediaQuery.of(context).size.width * percentage / 100,
          color: HexColor(color),
        )
      ],
    );
  }
}
