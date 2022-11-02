import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscuretext = true;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Sign up",
                  style: PairTaskerTheme.title1,
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "Email address",
                    hintText: "Enter your email",
                    prefixIcon: Container(
                        margin: const EdgeInsets.only(
                          right: 15,
                        ),
                        child: const Icon(Icons.email)),
                    labelStyle: PairTaskerTheme.inputLabel,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#99A4AE"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: _obscuretext,
                  // enableSuggestions: false,
                  // autocorrect: false,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "Password",
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(
                        right: 15,
                      ),
                      child: const Icon(Icons.key),
                    ),
                    suffixIcon: InkWell(
                      child: Icon(
                        _obscuretext
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _obscuretext ? Colors.grey : HexColor("#99A4AE"),
                      ),
                      onTap: () {
                        setState(() {
                          _obscuretext = !_obscuretext;
                        });
                      },
                    ),
                    hintText: "Enter password",
                    labelStyle: PairTaskerTheme.inputLabel,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#99A4AE"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  // enableSuggestions: false,
                  // autocorrect: false,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "Confirm Password",
                    hintText: "Re-Enter password",
                    prefixIcon: Container(
                        margin: const EdgeInsets.only(
                          right: 15,
                        ),
                        child: const Icon(Icons.key)),
                    labelStyle: PairTaskerTheme.inputLabel,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#99A4AE"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          activeColor: HexColor('#007FFF'),
                          value: isChecked,
                          onChanged: (bool? value) => {
                            setState(() {
                              isChecked = value!;
                            })
                          },
                        ),
                      ),
                    ),
                    Text(
                      'Policy and Terms',
                      style: GoogleFonts.nunito(
                        color: HexColor('#007FFF'),
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 90 / 100,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        context: context,
                        builder: (context) => Container(
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
                                  child: TextField(
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
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Resend Code in ',
                                      style: TextStyle(
                                        color: HexColor('#AAABAB'),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '0:48 sec',
                                      style: TextStyle(
                                          color: HexColor('FF033E'),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      90 /
                                      100,
                                  height: 43,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/userform');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor('007FFF'),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Verify',
                                      style: PairTaskerTheme.buttonText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 127, 255, 1),
                      elevation: 3,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    child: Text(
                      'Register',
                      style: PairTaskerTheme.buttonText,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already had account?',
                      style: TextStyle(
                        color: HexColor('#99A4AE'),
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: HexColor('#007FFF'),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
