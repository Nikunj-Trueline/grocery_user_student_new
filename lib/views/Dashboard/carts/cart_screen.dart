import 'package:flutter/material.dart';
import 'package:grocery_user_student/firebase/firebase_servicies.dart';

import '../../../model/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart Screen")),
      body: StreamBuilder(
        stream: FirebaseServicies().productGetFromCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            return _buildCartList(snapshot.data!);
          } else {
            return const Center(
              child: Text("No Cart Product Found"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          onPressed: () {},
          label: const Text("CheckOut"),
          icon: const Icon(Icons.shopping_basket)),
    );
  }

  Widget _buildCartList(List<Cart> cartItems) {
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
                          IconButton(
                            onPressed: () {
                              FirebaseServicies().removeProductFromCart(
                                  productId: cartItems[index].id);
                            },
                            icon: const Icon(
                              Icons.cancel_presentation_sharp,
                              color: Colors.grey,
                            ),
                          )
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
                            width: 20,
                          ),
                          Center(
                            child: Text(
                              "${cartItem.quantity}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
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
                            onTap: () {
                              // _updateQuantity(cartItem, isIncrement: true);
                            },
                          ),
                          Expanded(child: Container()),
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
