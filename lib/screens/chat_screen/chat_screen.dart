import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helpers/methods.dart';

class ChatScreen extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final screenType;

  const ChatScreen(this.screenType, {super.key});

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
                      if (screenType == 'user')
                        Text(
                          'PT000001A',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (screenType == 'tasker')
                        Row(
                          children: [
                            const SizedBox(
                              width: 42,
                              height: 42,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  'https://img.freepik.com/premium-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg?w=2000??',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Will Smith',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '@willsmith143',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: HexColor('#AAABAB'),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
            if (screenType == 'user')
              Container(
                margin: const EdgeInsets.only(
                  top: 6,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                color: Helper.isDark(context)
                    ? HexColor('252B30')
                    : HexColor('E4ECF5'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Stack(
                        children: const [
                          CircleAvatar(
                            radius: 13,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/premium-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg?w=2000??',
                            ),
                          ),
                          Positioned(
                            left: 18.0,
                            child: CircleAvatar(
                              radius: 13,
                              backgroundImage: NetworkImage(
                                'https://img.freepik.com/premium-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg?w=2000',
                              ),
                            ),
                          ),
                          Positioned(
                            left: 38.0,
                            child: CircleAvatar(
                              radius: 13,
                              backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjdKRG2b-Z-wzIFPlATwulI-kKBy9LiKNcpAdBG4u5mf2X3aVPp2p62JYts9jz-1ABOnI&usqp=CAU',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      'view status',
                      style: GoogleFonts.poppins(
                        color: HexColor('007FFF'),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 6,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 12,
              ),
              color: Helper.isDark(context)
                  ? HexColor('252B30')
                  : HexColor('E4ECF5'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requested message',
                    style: GoogleFonts.poppins(
                      color: HexColor('007FFF'),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Naaku oka 2 liters milk packet kaavali. And some vegetables. I will pay you 40 rupees .......more., ',
                    style: GoogleFonts.lato(
                      color: HexColor('6F7273'),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (screenType == 'user')
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Helper.isDark(context)
                              ? HexColor('252B30')
                              : HexColor('DEE0E0'),
                        ),
                        child: Text(
                          'willsmith143 accepted your request',
                          style: GoogleFonts.lato(
                            color: HexColor('99A4AE'),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 150,
                        minHeight: 40,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor('007FFF'),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Hello',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 150,
                        minHeight: 40,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Helper.isDark(context)
                              ? HexColor('252B30')
                              : HexColor('DEE0E0'),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Hello',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 8 / 100,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Helper.isDark(context)
                      ? HexColor('252B30')
                      : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color:
                          Helper.isDark(context) ? Colors.white : Colors.black,
                      width: 0.2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 270,
                      decoration: BoxDecoration(
                        color: Helper.isDark(context)
                            ? HexColor('FFFFFF')
                            : HexColor('E4ECF5'),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type....",
                          hintStyle: GoogleFonts.lato(
                            color: Helper.isDark(context)
                                ? HexColor('252B30')
                                : HexColor('AAABAB'),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.camera_alt,
                      color: HexColor('99A4AE'),
                      size: 28,
                    ),
                    Icon(
                      Icons.send,
                      color: HexColor('007FFF'),
                      size: 32,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
