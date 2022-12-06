import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../helpers/methods.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 70, 40, 50),
              child: Image.asset('assets/images/name_logo.png'),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/network.svg",
                        width: 350,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text("A network of users and taskers"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/selecting_person.svg",
                        height: 200,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                          "Find and Hire the nearby people who can work for you.")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/self_employment.svg",
                        height: 200,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text("Become a tasker and be a boss for yourself.")
                    ],
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: const SlideEffect(
                        spacing: 8.0,
                        radius: 4.0,
                        dotWidth: 24.0,
                        dotHeight: 8.0,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 0.5,
                        dotColor: Colors.lightBlue,
                        activeDotColor: Color.fromRGBO(0, 127, 255, 1)),
                    onDotClicked: (index) => pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.bounceOut),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 127, 255, 1),
                      fixedSize: const Size.fromWidth(250),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Get started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a user?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color.fromRGBO(0, 127, 255, 1),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
