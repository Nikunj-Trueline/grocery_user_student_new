import 'package:flutter/material.dart';
import 'package:grocery_user_student/firebase/firebase_servicies.dart';
import 'package:grocery_user_student/model/product_model.dart';
import 'package:grocery_user_student/widgets/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  Product product;

  ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLoading = false;

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Center(
                child: Hero(
              tag: "Products${widget.product.id}",
              child: Image(
                  image: NetworkImage(widget.product.imageUrl),
                  height: 200,
                  width: 200),
            )),
            const SizedBox(
              height: 30,
            ),
            Text("Product Name : ${widget.product.name}"),
            const SizedBox(
              height: 30,
            ),
            Text("product Price : ${widget.product.price}"),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      }
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(
                  width: 10,
                ),
                 Text(quantity.toString()),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {});
                    quantity++;
                  },
                  child: const Icon(Icons.add),
                ),
                const Spacer(),
                 Text("Total Price: ${quantity* widget.product.price}"),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomButton(
                  title: "Add to Cart",
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white70,
                  callback: () {
                    addToCart(widget.product,quantity,context);
                  },
                  isLoading: isLoading),
            )
          ],
        ),
      ),
    );
  }

  void addToCart(Product product,int quantity,BuildContext context)
  {
    try{
      FirebaseServicies().addToProductInCart(product: product, quantity: quantity,context: context);
    }catch(e)
    {

    }

  }
}
