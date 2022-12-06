import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:provider/provider.dart';
import '../helpers/methods.dart';
import '../theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:http/http.dart' as http;

class OtpVerification extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final email;
  // ignore: prefer_typing_uninitialized_variables
  final password;
  const OtpVerification(this.email, this.password, {super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final formKey = GlobalKey<FormState>();
  final otp = TextEditingController();
  var error = '';
  bool isLoading = false;
  bool isTimerEnded = false;

  void verifyOTP() async {
    setState(() {
      error = '';
    });
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await Provider.of<Auth>(context, listen: false).verifyotp(
      widget.email,
      otp.text,
    );
    if (response.statusCode != 200) {
      setState(() {
        error = response.body;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/userform');
    }
  }

  void resendOTP() async {
    setState(() {
      error = '';
    });
    var url = Uri.parse('https://pairtasker.herokuapp.com/api/auth/register');
    var res = await http.post(url, body: {
      'email': widget.email,
      'password': widget.password,
      'tremsAgreed': true.toString()
    });
    if (res.statusCode == 200) {
      setState(() {
        isTimerEnded = false;
      });
    } else {
      setState(() {
        error = res.body;
      });
    }
  }

  void onTimerEnd() {
    setState(() {
      isTimerEnded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Helper.isDark(context) ? Colors.black : Colors.white,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Verify your mail',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: otp,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Valid OTP';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: HexColor('AAABAB'),
                          ),
                        ),
                        hintText: "CODE",
                      ),
                    ),
                  ),
                ),
                if (error != '')
                  Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      ErrorMessage(error)
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (isTimerEnded)
                  Center(
                    child: TextButton(
                      onPressed: resendOTP,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: HexColor('007FFF'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (!isTimerEnded)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Resend Code:',
                        style: GoogleFonts.lato(
                          color: HexColor('#AAABAB'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CountdownTimer(
                        endTime:
                            DateTime.now().millisecondsSinceEpoch + 1000 * 60,
                        onEnd: onTimerEnd,
                        textStyle: GoogleFonts.lato(
                          color: HexColor('FF033E'),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 90 / 100,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('007FFF'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    child: isLoading
                        ? const LoadingSpinner()
                        : Text(
                            'Verify',
                            style: PairTaskerTheme.buttonText,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
