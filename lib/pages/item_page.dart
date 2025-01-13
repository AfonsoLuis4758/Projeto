import 'package:flutter/material.dart';
import 'package:rowbuilder/rowbuilder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});
  @override
  State<ItemPage> createState() => _ItemPage();
}

Future wishlistCall(wish) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? futureToken = prefs.getString('token');
  final String? email = prefs.getString('email');
  String token = futureToken!.substring(1, futureToken.length - 1);

  http.Response response;
  response = await http.put(
    Uri.parse("http://localhost:5000/user/wishlist/$email"),
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({"wishlist": wish}),
  );
  if (response.statusCode == 200) {
    print("posted");
    return json.decode(response.body);
  }
}

Future cartCall(item) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? futureToken = prefs.getString('token');
  final String? email = prefs.getString('email');
  String token = futureToken!.substring(1, futureToken.length - 1);

  http.Response response;
  response = await http.put(
    Uri.parse("http://localhost:5000/user/cart/$email"),
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({"cart": item}),
  );
  if (response.statusCode == 200) {
    print("posted");
    return json.decode(response.body);
  }
}

class _ItemPage extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Color discountColor = Colors.white;
    bool isPressed = arguments["wishlisted"];
    String discountPrice = "";
    if (arguments["promotion"] != 0) {
      discountColor = Colors.black;
      discountPrice = arguments["price"].toString();
    }
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
        Hero(
            tag: "herotag" + arguments['id'],
            child: Image.memory(
              base64Decode(arguments["image"].replaceAll("-", "/")),
              height: 400.0,
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(arguments['name'], style: TextStyle(fontSize: 30)),
              Expanded(child: SizedBox()),
              InkWell(
                  onTap: () async {
                    setState(() {
                      isPressed = !isPressed;
                    });
                    await wishlistCall(arguments["id"]);
                  },
                  child: Icon(
                    Icons.favorite,
                    color: isPressed ? Colors.red : Colors.green,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              RowBuilder(
                  itemCount: arguments["color"].length,
                  reversed: false,
                  itemBuilder: (BuildContext context, int index) {
                    Color currentColor = Colors.blue;
                    switch (arguments["color"][index]) {
                      case "blue":
                        currentColor = Colors.blue;
                        break;
                      case "green":
                        currentColor = Colors.green;
                        break;
                      case "yellow":
                        currentColor = Colors.yellow;
                        break;
                      case "red":
                        currentColor = Colors.red;
                        break;
                      case "black":
                        currentColor = Colors.black;
                        break;
                      case "white":
                        currentColor = Colors.white;
                        break;
                      default:
                    }
                    return Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: currentColor,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
              Expanded(child: SizedBox()),
              Row(
                children: [
                  Text(
                      (arguments['price'] *
                              (1 - (arguments["promotion"] / 100)))
                          .toString(),
                      style: TextStyle(fontSize: 40)),
                  Text(discountPrice,
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: discountColor))
                ],
              )
            ],
          ),
        ),
        RowBuilder(
            itemCount: arguments["sizes"].length,
            reversed: false,
            itemBuilder: (BuildContext context, int index) {
              return CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: Text(arguments["sizes"][index],
                      style: TextStyle(fontSize: 30, color: Colors.white)));
            }),
        Expanded(child: SizedBox()),
        ElevatedButton(
            onPressed: () async {
              await cartCall(arguments["id"]);
              await wishlistCall(arguments["id"]);
            },
            child: const Text(
              "Adicionar ao carrinho",
              style: TextStyle(fontSize: 24),
            )),
      ]),
    );
  }
}
