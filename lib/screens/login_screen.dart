import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../helpers/methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscuretext = true;
  final email = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;
  String error = '';

  Future<void> signIn() async {
    setState(() {
      error = '';
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await Provider.of<Auth>(context, listen: false).signIn(
      email.text,
      password.text,
      context,
    );
    if (response.statusCode != 200) {
      setState(() {
        error = response.data['message'] ??
            'Something went wrong! please, try again.';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> forgotPassword() async {
    setState(() {
      error = '';
    });
    if (email.text.isEmpty) {
      setState(() {
        error = 'Email should not be empty';
      });
      return;
    }
    final response =
        await Provider.of<Auth>(context, listen: false).forgotPassword(
      email.text,
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
  }

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
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    controller: email,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!!';
                      }
                      return null;
                    },
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
                  TextFormField(
                    obscureText: _obscuretext,
                    controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This Field is required';
                      }
                      return null;
                    },
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
                          color:
                              _obscuretext ? Colors.grey : HexColor("#99A4AE"),
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
                        onPressed: forgotPassword,
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
                    height: 10,
                  ),
                  if (error != '')
                    Column(
                      children: [
                        ErrorMessage(error),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 90 / 100,
                    height: 43,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#007FFF'),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      child: isLoading
                          ? const LoadingSpinner()
                          : Text('Login', style: PairTaskerTheme.buttonText),
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
      ),
    );
  }
}
