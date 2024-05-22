import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_user_student/model/cart_model.dart';
import 'package:grocery_user_student/model/category_model.dart';
import 'package:grocery_user_student/model/product_model.dart';
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

      UserData userData = UserData.fromJson(dataSnapshot.value);

      return userData;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Stream<List<Product>> topSellingProducts() {
    return firebaseDatabase
        .ref()
        .child("Products")
        .orderByChild("inTop")
        .equalTo(true)
        .onValue
        .map((event) {
      List<Product> productList = [];

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> topSelling =
            event.snapshot.value as Map<dynamic, dynamic>;

        topSelling.forEach((key, value) {
          Product product = Product.fromJson(value);
          productList.add(product);
        });
      }

      return productList;
    });
  }

  Stream<List<Product>> getAllProductParticularCategory(
      {required String categoryId}) {
    return firebaseDatabase
        .ref()
        .child("Products")
        .orderByChild("categoryId")
        .equalTo(categoryId)
        .onValue
        .map((event) {
      List<Product> productList = [];

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> productMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        productMap.forEach((key, value) {
          Product product = Product.fromJson(value);
          productList.add(product);
        });
      }

      return productList;
    });
  }

  Future<void> addToProductInCart(
      {required Product product,
      required int quantity,
      required BuildContext context}) async {
    try {
      String userId = firebaseAuth.currentUser!.uid;

      DatabaseReference ref = firebaseDatabase
          .ref()
          .child("UserCart")
          .child(userId)
          .child("Products")
          .child(product.id!);

      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        ref.update({
          "quantity": quantity,
          "totalPrice": (quantity * product.price).toDouble()
        });
      } else {
        Cart cart = Cart(
            id: product.id!,
            name: product.name,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl,
            quantity: quantity,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            totalPrice: (quantity * product.price).toDouble());

        ref.set(cart.toJson());

        log("Product successfully add into cart");
      }

      Navigator.pop(context);
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<Cart>> productGetFromCart() {
    String userId = firebaseAuth.currentUser!.uid;

    return firebaseDatabase
        .ref()
        .child("UserCart")
        .child(userId)
        .child("Products")
        .onValue
        .map((event) {
      List<Cart> cartList = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> cartMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        cartMap.forEach((key, value) {
          Cart cart = Cart.fromJson(value);

          cartList.add(cart);
        });
      }

      return cartList;
    });
  }

  void removeProductFromCart({required String productId}) {
    String userId = firebaseAuth.currentUser!.uid;

    try {
      firebaseDatabase
          .ref()
          .child("UserCart")
          .child(userId)
          .child("Products")
          .child(productId)
          .remove();
    } catch (e) {
      log(e.toString());
    }
  }

  void updateCartProduct({required String cartId, required Cart cart}) {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      firebaseDatabase
          .ref()
          .child("UserCart")
          .child(userId)
          .child("Products")
          .child(cartId)
          .update(cart.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<Cart>> cartItemsForTotalPrice() {

    String userId = firebaseAuth.currentUser!.uid;
    print(userId);


    return firebaseDatabase
        .ref()
        .child("UserCart")
        .child(userId)
        .child("Products")
        .onValue
        .map((event) {


      List<Cart> cartList = [];



      if (event.snapshot.exists) {


        Map<dynamic, dynamic> cartMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        print("This is cartMap ");
        print(cartMap);

        cartMap.forEach((key, value) {
          Cart cart = Cart.fromJson(value);cartList.add(cart);
        });
      }
      return cartList;
    });
  }
}
