import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/screens/chat_screen/view_image.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class RequestNotification extends StatefulWidget {
  final description;
  final profilePicture;
  final username;
  final taskId;
  final image;

  const RequestNotification(
      {this.description,
      this.profilePicture,
      this.username,
      this.taskId,
      this.image,
      super.key});

  @override
  State<RequestNotification> createState() => _RequestNotificationState();
}

class _RequestNotificationState extends State<RequestNotification> {
  bool isAccepting = false;
  bool isRejecting = false;

  Future<void> acceptRequest(String taskId, bool accept) async {
    if (accept) {
      setState(() {
        isAccepting = true;
      });
    } else {
      setState(() {
        isRejecting = true;
      });
    }
    final response =
        await Provider.of<Tasker>(context, listen: false).acceptRequest(
      taskId,
      accept,
    );
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(
          seconds: 2,
        ),
        backgroundColor: HexColor('007FFF'),
        content: Text(
          response.data['message'],
          style: GoogleFonts.poppins(
            // ignore: use_build_context_synchronously
            color: Helper.isDark(context) ? Colors.white : Colors.black,
          ),
        ),
      ));
      if (accept) {
        // ignore: use_build_context_synchronously
        final navigator = Navigator.of(context);
        Future.delayed(const Duration(seconds: 2), () {
          navigator.pushReplacementNamed('/mytasks');
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(
          seconds: 2,
        ),
        backgroundColor: HexColor('FF033E'),
        content: Text(
          response.data['message'] ??
              'Something went wrong! please, try again.',
          style: GoogleFonts.poppins(
            // ignore: use_build_context_synchronously
            color: Helper.isDark(context) ? Colors.white : Colors.black,
          ),
        ),
      ));
    }
    if (accept) {
      setState(() {
        isAccepting = false;
      });
    } else {
      setState(() {
        isRejecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Helper.isDark(context) ? HexColor('252B30') : HexColor('E4ECF5'),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: widget.profilePicture == null
                      ? const AssetImage(
                          'assets/images/default_user.png',
                        )
                      : NetworkImage(widget.profilePicture) as ImageProvider,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            ReadMoreText(
              widget.description,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'more',
              trimExpandedText: 'less',
              trimLines: 2,
              moreStyle: GoogleFonts.lato(
                color: HexColor('007FFF'),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              lessStyle: GoogleFonts.lato(
                color: HexColor('007FFF'),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              style: TextStyle(
                color: Helper.isDark(context)
                    ? HexColor('99A4AE')
                    : HexColor('#6F7273'),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.image.toString().isNotEmpty)
              const SizedBox(
                height: 5,
              ),
            if (widget.image.toString().isNotEmpty)
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewImage(
                      Image: widget.image,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      widget.image,
                      height: 30,
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: SvgPicture.asset(
                        'assets/images/image.svg',
                      ),
                    )
                  ],
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: HexColor('#FF033E'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                    onPressed: () => acceptRequest(widget.taskId, false),
                    child: isRejecting
                        ? const LoadingSpinner()
                        : const Text(
                            'Reject',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: 130,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: HexColor('#32DE84'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                    onPressed: () => acceptRequest(widget.taskId, true),
                    child: isAccepting
                        ? const LoadingSpinner()
                        : const Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WarningNotification extends StatelessWidget {
  const WarningNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: !Helper.isDark(context)
            ? const Color.fromRGBO(255, 199, 44, 0.25)
            : null,
        gradient: Helper.isDark(context)
            ? const LinearGradient(
                colors: [Color.fromRGBO(255, 199, 44, 0.25), Colors.white],
                begin: Alignment(0, 0),
                end: Alignment(0, 0),
              )
            : null,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Image.asset(
                    'assets/images/icons/warning.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 3,
                  ),
                  child: Text(
                    'Warning',
                    style: TextStyle(
                      color: HexColor('1A1E1F'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              'Please update your mobile number !!!',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: HexColor('#6F7273'),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementNotification extends StatelessWidget {
  const AnnouncementNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: HexColor('#007FFF'),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Image.asset(
                    'assets/images/icons/announcement.png',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 3,
                  ),
                  child: const Text(
                    'New version Update 🎉🎉🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              'Download the latest vesion of Piartasker by clicking here. ..',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: HexColor('#E4ECF5'),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
