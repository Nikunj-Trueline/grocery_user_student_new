import 'package:flutter/material.dart';
import 'package:grocery_user_student/views/Dashboard/account/account_screen.dart';
import 'package:grocery_user_student/views/Dashboard/cartscreen/cart_screen.dart';
import 'package:grocery_user_student/views/Dashboard/favouritescreen/favourite_screen.dart';
import 'package:grocery_user_student/views/Dashboard/shopscreen/shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List screens = [
    const ShopScreen(),
    const FavouriteScreen(),
    const CartScreen(),
    const AccountScreen()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          selectedIconTheme: const IconThemeData(
            color: Colors.amber
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.black
          ),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Shop"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "favourite"),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_travel), label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts), label: "Account")
          ],
          currentIndex: currentIndex),
    );
  }
}
