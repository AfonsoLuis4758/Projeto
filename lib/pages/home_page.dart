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
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text("Filter")),
              ElevatedButton(
                  onPressed: () {},
                  child: const Icon(
                    Icons.grid_3x3,
                    color: Colors.white,
                  ))
            ],
          ),
          Expanded(
            child: GridView.count(
              childAspectRatio: (1 / 1.5),
              crossAxisCount: 2,
              children: List.generate(20, (index) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, "/creationpage");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
