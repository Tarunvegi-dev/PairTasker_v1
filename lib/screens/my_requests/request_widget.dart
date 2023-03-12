import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/screens/screens.dart';

class RequestWidget extends StatelessWidget {
  final id;
  final requestId;
  final message;
  final status;
  final currentTasker;
  final fetchRequests;

  const RequestWidget(
      {this.message,
      this.id,
      this.status = 0,
      this.currentTasker,
      this.requestId,
      this.fetchRequests,
      super.key});

  @override
  Widget build(BuildContext context) {
    final page = ChatScreen(
      screenType: 'user',
      taskId: id.toString(),
    );
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      )
          .then((value) {
        fetchRequests();
      }),
      child: Container(
        color: Helper.isDark(context) ? Colors.black : Colors.white,
        margin: const EdgeInsets.only(bottom: 5),
        // height: 120,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        requestId,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentTasker != '')
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            '@$currentTasker',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: HexColor('AAABAB'),
                            ),
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
