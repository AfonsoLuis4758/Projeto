import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        childAspectRatio: (1 / 1.5),
        crossAxisCount: 2,
        children: List.generate(20, (index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/itempage", arguments: {
                    "image": "assets/images/pants.jpg",
                    "name": "Pants nº $index"
                  });
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/pants.jpg"),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Nome do Produto"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          );
        }),
      ),
    );
  }
}
