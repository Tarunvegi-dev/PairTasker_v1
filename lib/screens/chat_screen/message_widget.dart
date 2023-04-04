import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/screens/chat_screen/view_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class OutgoingMessage extends StatefulWidget {
  final message;
  final image;
  final timestamp;
  final showMsgStatus;
  final msgStatus;
  final isPrompt;
  const OutgoingMessage(
      {this.message,
      this.image,
      this.timestamp,
      this.showMsgStatus,
      this.msgStatus,
      this.isPrompt,
      super.key});

  @override
  State<OutgoingMessage> createState() => _OutgoingMessageState();
}

class _OutgoingMessageState extends State<OutgoingMessage> {
  File? myFile;

  Future<void> convertUrlToFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = path.join(dir.path, path.basename(widget.image));
    setState(() {
      myFile = File(pathName);
    });
  }

  @override
  void initState() {
    convertUrlToFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final datetime = DateTime.parse(widget.timestamp).toLocal();
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
                padding:
                    widget.image.toString().isNotEmpty && widget.image != null
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
                    widget.image.toString().isNotEmpty
                        ? InkWell(
                            onTap: widget.image.toString().isNotEmpty
                                ? () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ViewImage(
                                        Image: widget.image,
                                      ),
                                    ))
                                : () {},
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: Image(
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
                                image: NetworkToFileImage(
                                  url: widget.image,
                                  file: myFile,
                                  debug: true,
                                ),
                              ),
                            ),
                          )
                        : !widget.isPrompt
                            ? Text(
                                widget.message,
                                style: GoogleFonts.lato(
                                    fontSize: 14, color: Colors.white),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'I want you to confirm the task',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Please consider confirming the task, if you are sure about the task.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                    ),
                                  )
                                ],
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
                  if (widget.showMsgStatus)
                    Text(
                      '${widget.msgStatus} at ${datetime.hour}: ${datetime.minute < 10 ? '0${datetime.minute}' : '${datetime.minute}'} ${datetime.hour >= 12 ? 'PM' : 'AM'} ',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                        fontSize: 8,
                        color: HexColor('AAABAB'),
                      ),
                    ),
                  if (!widget.showMsgStatus)
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

class IncomingMessage extends StatefulWidget {
  final message;
  final screenType;
  final sender;
  final image;
  final timestamp;
  final isPrompt;
  final senderImage;

  const IncomingMessage(
      {this.message,
      this.screenType,
      this.isPrompt,
      this.sender,
      this.senderImage,
      this.image,
      this.timestamp,
      super.key});

  @override
  State<IncomingMessage> createState() => _IncomingMessageState();
}

class _IncomingMessageState extends State<IncomingMessage> {
  File? myFile;

  Future<void> convertUrlToFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = path.join(dir.path, path.basename(widget.image));
    setState(() {
      myFile = File(pathName);
    });
  }

  @override
  void initState() {
    convertUrlToFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final datetime = DateTime.parse(widget.timestamp).toLocal();
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(
          left: 16,
          top: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isPrompt)
              CircleAvatar(
                radius: 22,
                backgroundImage: widget.senderImage != null
                    ? NetworkImage(widget.senderImage)
                    : const AssetImage('assets/images/default_user.png')
                        as ImageProvider,
              ),
            Container(
              margin: EdgeInsets.only(
                left: widget.isPrompt ? 10 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 130,
                      maxWidth: 280,
                      minHeight: 35,
                    ),
                    child: Container(
                      padding: widget.image.toString().isNotEmpty &&
                              widget.message.toString().isEmpty
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
                          if (widget.screenType == 'user' && !widget.isPrompt)
                            Container(
                              margin: const EdgeInsets.only(
                                bottom: 5,
                              ),
                              child: Text(
                                '@${widget.sender}'.replaceAll(' ', ''),
                                style: GoogleFonts.lato(
                                    color: HexColor('007FFF'),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          widget.image.toString().isNotEmpty
                              ? InkWell(
                                  onTap: widget.image.toString().isNotEmpty
                                      ? () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ViewImage(
                                              Image: widget.image,
                                            ),
                                          ))
                                      : () {},
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 300,
                                    ),
                                    child: Image(
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
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
                                      image: NetworkToFileImage(
                                          url: widget.image,
                                          file: myFile,
                                          debug: true),
                                    ),
                                  ),
                                )
                              : !widget.isPrompt
                                  ? Text(
                                      widget.message,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          '${widget.sender} wants you to confirm the task',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: HexColor('007FFF'),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'please choose below options to confirm/cancel this prompt, by confirming you are not able to continue to chat further. So, please check while you can confirm or not.',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                          ),
                                        )
                                      ],
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
