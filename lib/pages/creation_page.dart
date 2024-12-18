import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreationPage extends StatefulWidget {
  const CreationPage({super.key});
  @override
  State<CreationPage> createState() => _CreationPage();
}

class _CreationPage extends State<CreationPage> {
  String name = '';
  String type = '';
  String gender = '';
  String price = "";
  String stock = "";
  bool recent = true;
  List colors = [];
  List sizes = [];

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final genderController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  Future apiCall(
      name, type, stock, gender, price, colors, sizes, recent) async {
    final String? token = await getToken();
    print(token);
    http.Response response;
    response = await http.post(
      Uri.parse("http://localhost:5000/products"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": name,
        "type": type,
        "stock": stock,
        "gender": gender,
        "price": price,
        "color": colors,
        "sizes": sizes,
        "recent": recent
      }),
    );

    if (response.statusCode == 200) {
      print("posted");
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text(
          "LusoVest",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: ListView(
        children: [
          IconButton(
            iconSize: 200,
            icon: const Icon(
              Icons.camera_alt_rounded,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o nome do produto',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: typeController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o tipo de produto',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: genderController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o genero de produto',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o preço do produto',
              ),
            ),
          ),
          Row(
            children: [
              Column(
                children: [
                  const Text("Tamanhos"),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("S");
                                  } else {
                                    sizes.remove(colors.indexOf("S"));
                                  }
                                }),
                            const Text("S")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("M");
                                  } else {
                                    sizes.remove(colors.indexOf("M"));
                                  }
                                }),
                            const Text("M")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("L");
                                  } else {
                                    sizes.remove(colors.indexOf("L"));
                                  }
                                }),
                            const Text("L")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("XL");
                                  } else {
                                    sizes.remove(colors.indexOf("XL"));
                                  }
                                }),
                            const Text("XL")
                          ],
                        )
                      ]),
                ],
              ),
              Expanded(child: SizedBox()),
              Column(
                children: [
                  const Text("Cores"),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Azul");
                                    print(colors);
                                  } else {
                                    colors.remove(colors.indexOf("Azul"));
                                  }
                                }),
                            const Text("Azul")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Verde");
                                    setState(() {
                                      value = true;
                                    });
                                  } else {
                                    colors.remove(colors.indexOf("Verde"));
                                  }
                                }),
                            const Text("Verde")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) {}),
                            const Text("Amarelo")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Vermelho");
                                  } else {
                                    colors.remove(colors.indexOf("Vermelho"));
                                  }
                                }),
                            const Text("Vermelho")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Preto");
                                  } else {
                                    colors.remove(colors.indexOf("Preto"));
                                  }
                                }),
                            const Text("Preto")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: false,
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Branco");
                                  } else {
                                    colors.remove(colors.indexOf("Branco"));
                                  }
                                }),
                            const Text("Branco")
                          ],
                        )
                      ]),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o Stock do produto',
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Checkbox(
                      value: true,
                      onChanged: (value) {
                        if (value == true) {
                          setState(() {
                            recent = true;
                          });
                        } else {
                          setState(() {
                            recent = false;
                          });
                        }
                      }),
                  const Text("Novidade")
                ],
              )),
          Expanded(child: SizedBox()),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  type = typeController.text;
                  gender = genderController.text;
                  stock = stockController.text;
                  price = priceController.text;

                  apiCall(name, type, double.parse(stock), gender,
                      double.parse(price), colors, sizes, recent);
                });
              },
              child: const Text(
                "Adicionar",
                style: TextStyle(fontSize: 24),
              )),
        ],
      )),
    );
  }
}
