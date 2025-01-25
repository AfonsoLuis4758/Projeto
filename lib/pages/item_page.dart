import 'package:flutter/material.dart';
import 'package:rowbuilder/rowbuilder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/function/my-globals.dart' as globals;
import 'dart:convert';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});
  @override
  State<ItemPage> createState() => _ItemPage();
}

String ipv4 = globals.ip;

Future wishlistCall(wish) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? futureToken = prefs.getString('token');
  final String? email = prefs.getString('email');
  String token = futureToken!.substring(1, futureToken.length - 1);

  http.Response response;
  response = await http.put(
    Uri.parse("http://$ipv4:5000/user/wishlist/$email"),
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

Future cartCall(item, quantity, color, size) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? futureToken = prefs.getString('token');
  final String? email = prefs.getString('email');
  String token = futureToken!.substring(1, futureToken.length - 1);

  http.Response response;
  response = await http.put(
    Uri.parse("http://$ipv4:5000/user/cart/$email"),
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
        {"id": item, "quantity": quantity, "color": color, "size": size}),
  );
  if (response.statusCode == 200) {
    print("posted");
    return json.decode(response.body);
  }
}

class _ItemPage extends State<ItemPage> {
  late final arguments = (ModalRoute.of(context)?.settings.arguments ??
      <String, dynamic>{}) as Map;

  late String selectedColor = arguments["color"][0];
  late String selectedSize = arguments["sizes"][0];
  late bool isPressed = arguments["wishlisted"];
  bool adminVisibility = false;
  bool userVisibility = false;

  Future<void> _checkRoleAndNavigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    if (role == null) {
      Navigator.pushNamed(context, "/unloggedpage");
    } else {
      Navigator.pushNamed(context, "/mainpage", arguments: {
        "page": 2,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color discountColor = Colors.white;
    String discountPrice = "";
    if (arguments["promotion"] != 0) {
      discountColor = Colors.black;
      discountPrice = arguments["price"].toString();
    }
    List torsoSizes = ["XS", "S", "M", "L", "XL"];
    List pantsSizes = [34, 36, 38, 40, 42];
    List sizes = [];

    if (arguments["role"] == "admin") {
      adminVisibility = true;
      userVisibility = true;
    } else if (arguments["role"] == "user") {
      adminVisibility = false;
      userVisibility = true;
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.green[800],
        title: const Text(
          "LusoVest",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () async {
                await _checkRoleAndNavigate();
              })
        ],
      ),
      body: ListView(children: <Widget>[
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
              Visibility(
                visible: userVisibility,
                child: InkWell(
                    onTap: () async {
                      await wishlistCall(arguments["id"]);
                      setState(() {
                        isPressed = !isPressed;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: isPressed ? Colors.red : Colors.green,
                    )),
              )
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
                    Color currentColor =
                        Color(int.parse("0xff${arguments["color"][index]}"));
                    double containerSize = 40;
                    if (arguments["color"][index] == selectedColor) {
                      containerSize = 60;
                    }
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedColor = arguments["color"][index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: containerSize,
                          height: containerSize,
                          decoration: new BoxDecoration(
                            color: currentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
              Expanded(child: SizedBox()),
              Row(
                children: [
                  Text(
                      (arguments['price'] * (1 - arguments["promotion"] / 100))
                          .toStringAsFixed(2),
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
              if (arguments["type"] == "pants") {
                sizes.add(
                    pantsSizes[torsoSizes.indexOf(arguments["sizes"][index])]);
              } else {
                sizes.add(arguments["sizes"][index]);
              }
              double containerRadius = 26;
              if (arguments["sizes"][index] == selectedSize) {
                containerRadius = 36;
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedSize = arguments["sizes"][index];
                    });
                  },
                  child: CircleAvatar(
                      radius: containerRadius,
                      backgroundColor: Colors.green,
                      child: Text(sizes[index].toString(),
                          style: TextStyle(fontSize: 32, color: Colors.white))),
                ),
              );
            }),
        Visibility(
          visible: userVisibility,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
                onPressed: () async {
                  print(selectedSize);
                  await cartCall(
                      arguments["id"], 1, selectedColor, selectedSize);
                  await wishlistCall(arguments["id"]);
                },
                child: const Text(
                  "Adicionar ao carrinho",
                  style: TextStyle(fontSize: 24, color: Colors.black),
                )),
          ),
        ),
      ]),
      floatingActionButton: Visibility(
        visible: adminVisibility,
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.pushNamed(context, "/editproductpage", arguments: {
              "id": arguments["id"],
              "image": arguments["image"],
              "name": arguments["name"],
              "gender": arguments["gender"],
              "type": arguments["type"],
              "stock": arguments["stock"],
              "price": arguments["price"],
              "color": arguments["color"],
              "sizes": arguments["sizes"],
              "promotion": arguments["promotion"],
              "recent": arguments["recent"],
            });
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
