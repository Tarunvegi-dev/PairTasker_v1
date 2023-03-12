import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';

import 'package:pairtasker/screens/chat_screen/view_image.dart';

class OutgoingMessage extends StatelessWidget {
  final message;
  final image;
  final timestamp;
  final showMsgStatus;
  final msgStatus;
  const OutgoingMessage(
      {this.message,
      this.image,
      this.timestamp,
      this.showMsgStatus,
      this.msgStatus,
      super.key});

  @override
  Widget build(BuildContext context) {
    final datetime = DateTime.parse(timestamp);
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.only(
          right: 16,
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 130,
                minHeight: 35,
                maxWidth: 280,
              ),
              child: Container(
                padding: image.toString().isNotEmpty && image != null
                    ? const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      )
                    : const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                decoration: BoxDecoration(
                  color: HexColor('007FFF'),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image.toString().isNotEmpty
                        ? InkWell(
                            onTap: image.toString().isNotEmpty
                                ? () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ViewImage(
                                        Image: image,
                                      ),
                                    ))
                                : () {},
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: Image.network(
                                image,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                          )
                        : Text(
                            message,
                            style: GoogleFonts.lato(
                                fontSize: 14, color: Colors.white),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
                top: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showMsgStatus)
                    Text(
                      '$msgStatus at ${datetime.hour}: ${datetime.minute < 10 ? '0${datetime.minute}' : '${datetime.minute}'} ${datetime.hour >= 12 ? 'PM' : 'AM'} ',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                        fontSize: 8,
                        color: HexColor('AAABAB'),
                      ),
                    ),
                  if (!showMsgStatus)
                    Text(
                      '${datetime.hour}: ${datetime.minute < 10 ? '0${datetime.minute}' : '${datetime.minute}'} ${datetime.hour >= 12 ? 'PM' : 'AM'} ',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                        fontSize: 8,
                        color: HexColor('AAABAB'),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IncomingMessage extends StatelessWidget {
  final message;
  final screenType;
  final sender;
  final image;
  final timestamp;

  const IncomingMessage(
      {this.message,
      this.screenType,
      this.sender,
      this.image,
      this.timestamp,
      super.key});

  @override
  Widget build(BuildContext context) {
    final datetime = DateTime.parse(timestamp);
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(
          left: 16,
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: 130, maxWidth: 280, minHeight: 35),
              child: Container(
                padding:
                    image.toString().isNotEmpty && message.toString().isEmpty
                        ? const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          )
                        : const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (screenType == 'user')
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Text(
                          '@$sender'.replaceAll(' ', ''),
                          style: GoogleFonts.lato(
                              color: HexColor('007FFF'),
                              fontSize: 10,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    image.toString().isNotEmpty
                        ? InkWell(
                            onTap: image.toString().isNotEmpty
                                ? () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ViewImage(
                                        Image: image,
                                      ),
                                    ))
                                : () {},
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                          )
                        : Text(
                            message,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3, right: 8),
              child: Text(
                '${datetime.hour}: ${datetime.minute < 10 ? '0${datetime.minute}' : '${datetime.minute}'} ${datetime.hour >= 12 ? 'PM' : 'AM'} ',
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  fontSize: 8,
                  color: HexColor('AAABAB'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoMessage extends StatelessWidget {
  final message;
  const InfoMessage({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              Helper.isDark(context) ? HexColor('252B30') : HexColor('DEE0E0'),
        ),
        child: Text(
          message,
          style: GoogleFonts.lato(
            color: HexColor('99A4AE'),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class TaskMessage extends StatelessWidget {
  final message;
  final type;
  const TaskMessage({this.message, this.type, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Helper.isDark(context) ? HexColor('252B30') : HexColor('E4ECF5'),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: type == 'task-confirmation'
              ? HexColor('007FFF')
              : type == 'task-completion'
                  ? HexColor('32DE84')
                  : HexColor('FF033E'),
        ),
      ),
    );
  }
}
