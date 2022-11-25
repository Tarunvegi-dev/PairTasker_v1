import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../theme/theme.dart';
import '../helpers/methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscuretext = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      resizeToAvoidBottomInset: false,
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
                  "Login",
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
                      child: const Icon(Icons.email),
                    ),
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
                        child: const Icon(Icons.key)),
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
                      borderSide: BorderSide(color: HexColor("#99A4AE")),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        "forgot password ?",
                        style: TextStyle(
                          color: HexColor('007FFF'),
                          fontSize: 14,
                        ),
                      ),
                    ),
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
                      Navigator.pushNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#007FFF'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    child: Text('Login', style: PairTaskerTheme.buttonText),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: HexColor('#99A4AE'),
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/register');
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        'Register',
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
