import 'package:flutter/material.dart';
import 'package:grocery_user_student/firebase/firebase_servicies.dart';

import '../../model/category_model.dart';
import '../../model/product_model.dart';

class ProductListScreen extends StatefulWidget {
  Category category;
  ProductListScreen({super.key, required this.category});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: StreamBuilder(
            stream: FirebaseServicies().getAllProductParticularCategory(
                categoryId: widget.category.id!),
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
                List<Product> productList = snapshot.data!;

                return GridView.builder(
                  itemCount: productList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.black12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                              image: NetworkImage(productList[index].imageUrl),
                              height: 100,
                              width: 100),
                          Text(productList[index].name),
                          Text(productList[index].price.toString())
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No Product Found for this particular category"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
