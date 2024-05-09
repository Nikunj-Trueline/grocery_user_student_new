import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_user_student/model/category_model.dart';
import 'package:grocery_user_student/model/user_model.dart';

class FirebaseServicies {
  static final FirebaseServicies instance = FirebaseServicies.named();

  factory FirebaseServicies() {
    return instance;
  }

  FirebaseServicies.named();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future<bool> createUserAndStoreInDatabase(UserData userData) async {
    try {
      await firebaseDatabase
          .ref()
          .child('Users')
          .child(userData.id)
          .set(userData.toJson());

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // create method for check user already exist or not.

  Future<bool> userExistOrNot({required String id}) async {
    try {
      final snapshot =
          await firebaseDatabase.ref().child('Users').child(id).get();

      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // get categories

  Stream<List<Category>> getCategory() {
    return firebaseDatabase.ref().child("Category").onValue.map((event) {
      List<Category> categoryList = [];
      if (event.snapshot.exists) {
        Map categoryMap = event.snapshot.value as Map<dynamic, dynamic>;

        categoryMap.forEach((key, value) {
          final category = Category.fromJson(value);
          categoryList.add(category);
        });
      }

      return categoryList;
    });
  }

  // get current user data

  Future<UserData?> getUserData() async {
    try {
      var user = FirebaseAuth.instance.currentUser!.uid;

      DataSnapshot dataSnapshot =
          await firebaseDatabase.ref().child("Users").child(user).get();

      print(dataSnapshot.value);

      UserData userData = UserData.fromJson(dataSnapshot.value);

      return userData;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
