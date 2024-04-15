import 'package:flutter/material.dart';
import 'package:grocery_user_student/views/signin/signin_screen.dart';
import 'package:grocery_user_student/widgets/custom_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset("assets/intro_bg.png")),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset("assets/intro_bg_tran.png")),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Welcome \n to our store",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 10,
                  ),
                  Text("get your groceries in as fast as one hour",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      title: "Get Started ",
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      callback: () {
                        // Navigate signin Screen
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SigninScreen(),
                            ),
                            (route) => false);
                      },
                      isLoading: false)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
