import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user_student/views/verification/verification_screen.dart';
import 'package:grocery_user_student/widgets/custom_button.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final mobileNo = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage("assets/veggie_bg.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Get your groceries \n with nectar",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: mobileNo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter valid number";
                    } else if (value.length != 10) {
                      return "Please enter valid mobile number.";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: null,
                      labelText: "Enter Mobile No.",
                      prefixText: "+91",
                      suffixIcon: Icon(Icons.call)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomButton(
                    title: "Continue",
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    callback: () async {
                      // Navigate to Verification screen
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          String phoneNumber =
                              "+91${mobileNo.text.toString().trim()}";

                       await   FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNumber,
                            verificationCompleted:
                                (PhoneAuthCredential phoneAuthCredential) {
                              FirebaseAuth.instance
                                  .signInWithCredential(phoneAuthCredential);
                            },
                            verificationFailed: (error) {
                              // throw error
                              log(error.toString());
                            },
                            codeSent: (verificationId, forceResendingToken) {
                              // move verification screen
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerificationScreen(verificationId:verificationId ),
                                  ));
                            },
                            codeAutoRetrievalTimeout: (verificationId) {
                              //
                            },
                          );
                        } catch (e) {
                          log(e.toString());
                        }
                      }
                    },
                    isLoading: isLoading),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationScreen(),
                          ));
 */
