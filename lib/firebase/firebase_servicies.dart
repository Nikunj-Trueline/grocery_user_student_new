import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  // create method for check user alredy exist or not.

     Future<bool?> userExistOrNot({required String id})
     async {


         try{
            var snapshot = await firebaseDatabase.ref().child('Users').child(id).get();

            if(snapshot.exists)
              {
                return true;
              }else{
              return false;
            }


         }catch(e)
       {
         log(e.toString());
       }
     }
}
