import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../firebase/firebase_servicies.dart';
import '../../../model/category_model.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Top Categories.",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _buildHorizontalCategory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      onTap: () {},
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5.0),
        child: const TextField(
          showCursor: false,
          enabled: false,
          decoration: InputDecoration(
              hintText: "Search for products",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );
  }

  Widget _buildHorizontalCategory() {
    return SizedBox(
      height: 150,
      child: StreamBuilder<List<Category>>(
        stream: FirebaseServicies().getCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6, // Number of shimmer items
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasData) {




            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {

                final category = snapshot.data![index];

                return Container(
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          child: Image.network(
                            category.imageUrl,
                            width: 50,
                            height: 50,
                            //    color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
