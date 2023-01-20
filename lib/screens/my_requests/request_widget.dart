import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/screens/screens.dart';

class RequestWidget extends StatelessWidget {
  final requestId;
  final message;
  final status;
  final currentTasker;

  const RequestWidget(
      {this.message,
      this.status,
      this.currentTasker,
      this.requestId,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChatScreen('user'),
        ),
      ),
      child: Container(
        color: Helper.isDark(context) ? Colors.black : Colors.white,
        margin: const EdgeInsets.only(bottom: 5),
        height: 120,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'PT00001A',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentTasker != null)
                        Text(
                          currentTasker,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: HexColor('AAABAB'),
                          ),
                        )
                    ],
                  ),
                  Container(
                    color: status == '0'
                        ? Colors.black
                        : status == '1'
                            ? HexColor('FFC72C')
                            : status == '2'
                                ? HexColor('007FFF')
                                : status == '3'
                                    ? HexColor('32DE84')
                                    : HexColor('FF033E'),
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      status == '0'
                          ? 'Requested'
                          : status == '1'
                              ? 'CHAT'
                              : status == '2'
                                  ? 'CONFIRMED'
                                  : status == '3'
                                      ? 'COMPLETED'
                                      : 'CANCELLED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color:
                            status == '0' ? HexColor('007FFF') : Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  message.toString(),
                  style: TextStyle(
                    color: HexColor('6F7273'),
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
