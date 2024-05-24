import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user_student/firebase/firebase_servicies.dart';
import 'package:grocery_user_student/model/order_data.dart';
import 'package:grocery_user_student/views/addresslist/addresslist_screen.dart';
import 'package:grocery_user_student/widgets/custom_button.dart';

import '../../model/cart_model.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  double totalPrice = 0.0;

  List<Cart> totalPriceList = [];

  List<Cart> cartList = [];

  @override
  void initState() {
    calculateTotalPrice();
    super.initState();
  }

  Future<void> calculateTotalPrice() async {
    List<Cart> cartTotalPriceList =
        await FirebaseServicies().getTotalPriceForCheckOut();

    totalPriceList = cartTotalPriceList;

    calculateTotalSum();
  }

  void calculateTotalSum() {
    setState(() {
      totalPrice = totalPriceList.fold(
          0.0, (previousValue, element) => previousValue + element.totalPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CheckOut Screen")),
      body: StreamBuilder(
        stream: FirebaseServicies().productGetFromCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            return _buildCartList(snapshot.data!);
          } else {
            return Container();
          }
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CustomButton(
            title: "PlaceOrder : $totalPrice",
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            callback: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressListScreen(
                      orderData: OrderData(cartItems: cartList,totalAmount: totalPrice),
                    ),
                  ));
            },
            isLoading: false),
      ),
    );
  }

  Widget _buildCartList(List<Cart> cartItems) {
     cartList = cartItems;
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final Cart cartItem = cartItems[index];
        return Card(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.network(
                  cartItem.imageUrl,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cartItem.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${cartItems[index].price}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(),
                              ),
                              child: const Icon(Icons.remove),
                            ),
                            onTap: () {
                              // _updateQuantity(cartItem, isIncrement: false);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Center(
                            child: Text(
                              "${cartItem.quantity}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              // _updateQuantity(cartItem, isIncrement: true);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            "Rs. ${cartItem.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
