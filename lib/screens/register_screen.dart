import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/screens/otp_verification_screen.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../helpers/methods.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscuretext = true;
  bool _obscuretext2 = true;
  bool isTermsAgreed = false;
  bool isLoading = false;

  final email = TextEditingController();
  final password = TextEditingController();
  var error = '';

  Future<void> registerUser() async {
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
    final response = await Provider.of<Auth>(context, listen: false).signup(
      email.text,
      password.text,
      isTermsAgreed,
    );
    if (response.statusCode != 200) {
      setState(() {
        error = response.data['message'] ??
            'Something went wrong! please, try again.';
        isLoading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OtpVerification(email.text, password.text),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 10 / 100,
              ),
              child: Form(
                key: _formKey,
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
                    TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email!';
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
                    TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                .hasMatch(value)) {
                          setState(() {
                            setState(() {
                              error =
                                  'Password must contain an uppercase, a lowercase, a special character, and a number';
                            });
                          });
                        }
                        if (value.length < 8) {
                          return 'Password should contain at least 8 characters';
                        }
                        return null;
                      },
                      obscureText: _obscuretext,
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
                      validator: (value) {
                        if (value != password.text) {
                          return 'Passwords dont match!';
                        }
                        if (value!.length < 8) {
                          return 'Password should contain at least 8 characters';
                        }
                        return null;
                      },
                      obscureText: _obscuretext2,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          child: Icon(
                            _obscuretext2
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color:
                                _obscuretext ? Colors.grey : HexColor("#99A4AE"),
                          ),
                          onTap: () {
                            setState(() {
                              _obscuretext2 = !_obscuretext2;
                            });
                          },
                        ),
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
                      height: 20,
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
                              value: isTermsAgreed,
                              onChanged: (bool? value) => {
                                setState(() {
                                  isTermsAgreed = value!;
                                })
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed('/terms-and-conditions'),
                          child: Text(
                            'Terms and conditions',
                            style: GoogleFonts.nunito(
                              color: HexColor('#007FFF'),
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                    if (error != '')
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          ErrorMessage(error)
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 90 / 100,
                      height: 43,
                      child: ElevatedButton(
                        onPressed: isLoading ||
                                !isTermsAgreed ||
                                email.text.isEmpty ||
                                password.text.isEmpty
                            ? null
                            : registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 127, 255, 1),
                          elevation: 3,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        child: isLoading
                            ? const LoadingSpinner()
                            : Text(
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
                          style: GoogleFonts.lato(
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
                            style: GoogleFonts.lato(
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
      ),
    );
  }
}
