import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user_student/firebase/firebase_servicies.dart';
import 'package:grocery_user_student/model/user_model.dart';
import 'package:grocery_user_student/widgets/custom_button.dart';

import '../Dashboard/home_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: Stack(
        children: [
          const Image(
            image: AssetImage("assets/veggie_bg.png"),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 300,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Register Your\n Account",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter valid email";
                          } else {
                            return null;
                          }
                        },
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: null,
                          labelText: "Enter name",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter valid email";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          border: null,
                          labelText: "Enter Email",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: CustomButton(
                          title: "Register user",
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          callback: () {
                            if (formKey.currentState!.validate()) {
                              createUser(
                                  userName: nameController.text.toString(),
                                  userEmail: emailController.text.toString());
                            }
                          },
                          isLoading: isLoading),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> createUser(
      {required String userName, required String userEmail}) async {
    setState(() {
      isLoading = true;
    });
    try {
      UserData userData = UserData(
          id: user!.uid,
          contact: user!.phoneNumber.toString(),
          name: userName,
          email: userEmail,
          createdAt: DateTime.now().millisecondsSinceEpoch);

      bool status =
          await FirebaseServicies().createUserAndStoreInDatabase(userData);

      if (status) {
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
      }
    } catch (e) {
      print("1111111111111111111111111");
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
