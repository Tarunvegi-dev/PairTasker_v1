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
  final unreadCount;

  const RequestWidget(
      {this.message,
      this.id,
      this.status = 0,
      this.currentTasker,
      this.requestId,
      this.fetchRequests,
      this.unreadCount,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed('/chatscreen', arguments: {
            "screenType": 'user',
            "taskId": id.toString(),
          }).then((value) {
            fetchRequests();
          }),
          child: Container(
            color: Helper.isDark(context) ? Colors.black : Colors.white,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requestId,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (currentTasker != '')
                            Text(
                              '@$currentTasker',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: HexColor('AAABAB'),
                              ),
                            )
                          else if (int.parse(status) == 0)
                            Text(
                              'waiting to accept...',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: HexColor('AAABAB'),
                              ),
                            )
                          else
                            Text(
                              'terminated',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: HexColor('AAABAB'),
                              ),
                            )

                        ],
                      ),
                      Container(
                        color: status == '0'
                            ? Helper.isDark(context)
                                ? Colors.black
                                : Colors.white
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
                            color: status == '0'
                                ? HexColor('007FFF')
                                : Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * 80 / 100,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            message.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: HexColor('007FFF'),
                            shape: BoxShape.circle,
                          ),
                          child: Text(unreadCount.toString()),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: HexColor(
              Helper.isDark(context) ? '252B30' : '#E4ECF5',
            ),
          ),
          height: 3,
        )
      ],
    );
  }
}
