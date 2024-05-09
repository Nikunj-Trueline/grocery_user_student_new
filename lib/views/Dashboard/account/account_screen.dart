import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user_student/views/signin/signin_screen.dart';

import '../../../firebase/firebase_servicies.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile Account'),
      ),
      body: FutureBuilder(
        future: FirebaseServicies().getUserData(),
        // Replace 'your_user_id' with the actual user ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            print("snapshot.error : ${snapshot.hasError}");
            print("snapshot.data : ${snapshot.data == null}");
            return const Text('Error fetching user data');
          } else {
            var userData = snapshot.data;
            return ListView(
              children: [
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(16),
                  tileColor: Colors.white,
                  leading: Container(
                    height: 100,
                    color: Colors.white,
                    child: Image.asset(
                      "assets/user.png",
                    ),
                  ),
                  title: Text(
                    "UserName : ${userData!.name}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text('Contact : ${userData!.contact}'),
                  trailing: IconButton(
                    onPressed: () async {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: const Text(
                          'My Cart',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {},
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        leading: const Icon(Icons.note_alt_outlined),
                        title: const Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {},
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: const Icon(Icons.navigate_next),
                        onTap: () {
                          try {
                            FirebaseAuth.instance.signOut().then((value) {
                              // Navigate to signin screen

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SigninScreen(),
                                  ),
                                  (route) => false);
                            });
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

/*

Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile Account'),
      ),
      body: FutureBuilder(
        future: FirebaseService().getUserData(),
        // Replace 'your_user_id' with the actual user ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Text('Error fetching user data');
          } else {
            var userData = snapshot.data;
            return ListView(
              children: [
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(16),
                  tileColor: Colors.white,
                  leading: Container(
                    height: 100,
                    color: Colors.white,
                    child: Image.asset(
                      "assets/user.png",
                    ),
                  ),
                  title: const Text(
                    "",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: const Text('Contact : '),
                  trailing: IconButton(
                    onPressed: () async {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: const Text(
                          'My Cart',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {},
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        leading: const Icon(Icons.note_alt_outlined),
                        title: const Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {},
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: const Icon(Icons.navigate_next),
                        onTap: () {},
                      )
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
 */
