import 'package:flutter/material.dart';
import 'package:project/pages/main_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});
  @override
  State<ItemPage> createState() => _ItemPage();
}

class _ItemPage extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text(
          "LusoVest",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/mainpage", arguments: {
                "page": 2,
              });
            },
          )
        ],
      ),
      body: Column(children: <Widget>[
        Image(image: AssetImage(arguments['image'])),
        Row(
          children: [
            Text(arguments['name'], style: TextStyle(fontSize: 30)),
            Expanded(child: SizedBox()),
            Icon(
              Icons.favorite,
              color: Colors.green,
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: new BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: new BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(child: SizedBox()),
            Text("00.00€", style: TextStyle(fontSize: 40))
          ],
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Text('S',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Text('M',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Text('L',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
          ],
        ),
        Expanded(child: SizedBox()),
        ElevatedButton(
            onPressed: () {},
            child: const Text(
              "Comprar",
              style: TextStyle(fontSize: 24),
            )),
      ]),
    );
  }
}
