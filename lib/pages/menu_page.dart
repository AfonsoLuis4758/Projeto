import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  //secondPage

  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "LusoVest",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/profilepage");
            },
          )
        ],
      ),
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
                        children: [
                          Hero(
                              tag: "herotag",
                              child: Image.asset("assets/images/pants.jpg")),
                          Text('Pants nº $index'),
                        ],
                      ),
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
