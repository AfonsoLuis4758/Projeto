import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});
  @override
  State<EditProductPage> createState() => _EditProductPage();
}

class _EditProductPage extends State<EditProductPage> {
  List<int>? imgForApi;
  String source = "";
  String name = '';
  String type = '';
  String gender = '';
  String price = "";
  String stock = "";
  String promotion = "";
  bool recent = true;
  List colorCheckbox = [false, false, false, false, false, false];
  List sizeCheckbox = [false, false, false, false];
  List colors = [];
  List sizes = [];

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final genderController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final promotionController = TextEditingController();

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token;
  }

  Future apiCall(name, type, stock, gender, price, colors, sizes, recent,
      promotion, file, id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    //String base64Image = base64Encode(file);
    String token = futureToken!.substring(1, futureToken.length - 1);
    print(token);

    String? jsonBody;

    if (file != null) {
      String imgString = base64Encode(file);
      imgString = imgString.replaceAll("/", "-");
      jsonBody = jsonEncode({
        "name": name,
        "type": type,
        "stock": stock,
        "gender": gender,
        "price": price,
        "color": colors,
        "sizes": sizes,
        "recent": recent,
        "promotion": promotion,
        "image": imgString
      });
    } else {
      jsonBody = jsonEncode({
        "name": name,
        "type": type,
        "stock": stock,
        "gender": gender,
        "price": price,
        "color": colors,
        "sizes": sizes,
        "recent": recent,
        "promotion": promotion,
      });
    }
    http.Response response;
    response = await http.put(
      Uri.parse("http://localhost:5000/product/$id"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print("posted");
    } else {
      print("error");
    }
  }

  void takeSnapshot(source) async {
    final ImagePicker picker = ImagePicker();
    if (source == "camera") {
      final XFile? img = await picker.pickImage(
          source: ImageSource.camera, // alternatively, use ImageSource.gallery
          imageQuality: 80);
      if (img == null) return;
      imgForApi = await img.readAsBytes();
    }
    if (source == "gallery") {
      final XFile? img = await picker.pickImage(
          source: ImageSource.gallery, // alternatively, use ImageSource.gallery
          imageQuality: 80);
      if (img == null) return;
      imgForApi = await img.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    setState(() {
      nameController.text = arguments["name"];
      typeController.text = arguments["type"];
      genderController.text = arguments["gender"];
      priceController.text = arguments["price"].toString();
      stockController.text = arguments["stock"].toString();
      promotionController.text = arguments["promotion"].toString();
      recent = arguments["recent"];
    });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 150,
                icon: const Icon(
                  Icons.camera_alt_rounded,
                ),
                onPressed: () {
                  source = "camera";
                  takeSnapshot(source);
                },
              ),
              IconButton(
                iconSize: 150,
                icon: const Icon(
                  Icons.image,
                ),
                onPressed: () {
                  source = "gallery";
                  takeSnapshot(source);
                },
              ),
            ],
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
                                value: sizeCheckbox[0],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("S");
                                    setState(() {
                                      sizeCheckbox[0] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("S"));
                                    setState(() {
                                      sizeCheckbox[0] = false;
                                    });
                                  }
                                }),
                            const Text("S")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[1],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("M");
                                    setState(() {
                                      sizeCheckbox[1] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("M"));
                                    setState(() {
                                      sizeCheckbox[1] = false;
                                    });
                                  }
                                }),
                            const Text("M")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[2],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("L");
                                    setState(() {
                                      sizeCheckbox[2] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("L"));
                                    setState(() {
                                      sizeCheckbox[2] = false;
                                    });
                                  }
                                }),
                            const Text("L")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[3],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("XL");
                                    setState(() {
                                      sizeCheckbox[3] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("XL"));
                                    setState(() {
                                      sizeCheckbox[3] = false;
                                    });
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
                                value: colorCheckbox[0],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("blue");
                                    setState(() {
                                      colorCheckbox[0] = true;
                                    });
                                    print(colors);
                                  } else {
                                    colors.removeAt(colors.indexOf("blue"));
                                    setState(() {
                                      colorCheckbox[0] = false;
                                    });
                                  }
                                }),
                            const Text("Azul")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[1],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("green");
                                    setState(() {
                                      colorCheckbox[1] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("green"));
                                    setState(() {
                                      colorCheckbox[1] = false;
                                    });
                                  }
                                }),
                            const Text("Verde")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[2],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("yellow");
                                    setState(() {
                                      colorCheckbox[2] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("yellow"));
                                    setState(() {
                                      colorCheckbox[2] = false;
                                    });
                                  }
                                }),
                            const Text("Amarelo")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[3],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("red");
                                    setState(() {
                                      colorCheckbox[3] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("red"));
                                    setState(() {
                                      colorCheckbox[3] = false;
                                    });
                                  }
                                }),
                            const Text("Vermelho")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[4],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("black");
                                    setState(() {
                                      colorCheckbox[4] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("black"));

                                    setState(() {
                                      colorCheckbox[4] = false;
                                    });
                                  }
                                }),
                            const Text("Preto")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[5],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("white");
                                    setState(() {
                                      colorCheckbox[5] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("white"));

                                    setState(() {
                                      colorCheckbox[5] = false;
                                    });
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
            child: TextField(
              controller: promotionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza a promoção do produto',
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Checkbox(
                      value: recent,
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
                  promotion = promotionController.text;

                  apiCall(
                      name,
                      type,
                      double.parse(stock),
                      gender,
                      double.parse(price),
                      colors,
                      sizes,
                      recent,
                      double.parse(promotion),
                      imgForApi,
                      arguments["id"]);
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
