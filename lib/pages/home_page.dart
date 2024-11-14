import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //secondPage

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          childAspectRatio: (1 / 1.5),
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(20, (index) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    Image.asset("assets/images/pants.jpg"),
                    Text('Pants nº $index'),
                  ],
                ),
              ),
            ));
          }),
        ),
      ),
    );
  }
}
