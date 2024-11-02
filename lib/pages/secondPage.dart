import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  //secondPage

  const SecondPage({super.key});
  @override
  State<SecondPage> createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Product View",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Product View"),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          childAspectRatio: (1 / 1.5),
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(20, (index) {
            return Center(
                child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("images/pants.jpg"),
                  Text('Pants nº ${index}'),
                ],
              ),
            ));
          }),
        ),
      ),
    );
  }
}
