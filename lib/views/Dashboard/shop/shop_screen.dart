import 'package:flutter/material.dart';
import 'package:grocery_user_student/model/product_model.dart';
import 'package:grocery_user_student/views/product_details/product_detail_screen.dart';
import 'package:grocery_user_student/views/product_list/product_list_screen.dart';
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
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Top Selling Products.",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                buildTopSellingProductGrid(),
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                    category: snapshot.data![index]),
                              ));
                        },
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

  Widget buildTopSellingProductGrid() {
    return StreamBuilder(
        stream: FirebaseServicies().topSellingProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              itemCount: 6,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white70),
                        padding: const EdgeInsets.all(5),
                      ),
                    ));
              },
            );
          } else if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            List<Product> data = snapshot.data!;

            return GridView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: data[index]),
                          ));
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image(
                              image: NetworkImage(data[index].imageUrl),
                              height: 50,
                              width: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Name : ${data[index].name}"),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Price : ${data[index].price}")
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }
}
