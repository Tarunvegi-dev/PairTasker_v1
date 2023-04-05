import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';

class ApartmentWidget extends StatelessWidget {
  const ApartmentWidget({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.city,
    this.isSelected = false,
  }) : super(key: key);

  final String name;
  final String imageUrl;
  final String address;
  final String city;
  final isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: HexColor('007FFF')) : null,
        color: HexColor(
          Helper.isDark(context) ? '252B30' : '#E4ECF5',
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              width: 80,
              height: 100,
              fit: BoxFit.cover,
              image: NetworkImage(
                imageUrl,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                child: Text(
                  name,
                  style: GoogleFonts.poppins(
                      color: HexColor('007FFF'),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 60 / 100,
                height: 34,
                child: Text(
                  address,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    color: HexColor('AAABAB'),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                city,
                style: GoogleFonts.poppins(
                    color: HexColor('AAABAB'),
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }
}
