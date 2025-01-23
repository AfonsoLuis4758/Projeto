import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  List<String> genders = ["Homem", "Mulher"];
  List<String> gendersfromApi = ["male", "female"];
  List<String> types = [
    "Calças",
    "T-shirts",
    "Sweatshirts",
    "Casacos",
    "Calçado"
  ];
  List<String> typesfromApi = [
    "pants",
    "shirts",
    "sweatshirts",
    "jackets",
    "shoes"
  ];
  String price = "";
  String stock = "";
  String promotion = "";
  bool recent = true;
  List colorCheckbox = [false, false, false, false, false, false];
  List sizeCheckbox = [false, false, false, false, false];
  List sizes = [];
  bool textVisible = false;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final promotionController = TextEditingController();

  Widget cameraWidget = const SizedBox();
  Widget galleryWidget = const SizedBox();

  @override
  void initState() {
    super.initState();
    cameraWidget = IconButton(
      iconSize: 150,
      icon: const Icon(
        Icons.camera_alt_rounded,
      ),
      onPressed: () {
        source = "camera";
        takeSnapshot(source);
      },
    );

    galleryWidget = IconButton(
      iconSize: 150,
      icon: const Icon(
        Icons.image,
      ),
      onPressed: () {
        source = "gallery";
        takeSnapshot(source);
      },
    );
  }

  late final arguments = (ModalRoute.of(context)?.settings.arguments ??
      <String, dynamic>{}) as Map;

  String typeValue = "Calças";
  String genderValue = "Homem";

  setValues() {
    typeValue = typesfromApi[types.indexOf(arguments["type"])];
    genderValue = typesfromApi[types.indexOf(arguments["gender"])];
  }

  List<Color> ApiColors = [];
  List<Color> currentColors = [];

// ValueChanged<Color> callback
  void changeColors(List<Color> colors) {
    setState(() => currentColors = colors);
  }

  void ColorPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: MultipleChoiceBlockPicker(
                pickerColors: currentColors,
                onColorsChanged: changeColors,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Got it'),
                onPressed: () {
                  setState(() => ApiColors = currentColors);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

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
      setState(() {
        textVisible = true;
      });
      print("error");
    }
  }

  Future deleteCall(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    //String base64Image = base64Encode(file);
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.delete(
      Uri.parse("http://localhost:5000/product/$id"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
      Uint8List imgWidget = await img.readAsBytes();
      setState(() {
        cameraWidget = InkWell(
            onTap: () {
              source = "camera";
              takeSnapshot(source);
            },
            child: Image.memory(imgWidget, width: 150));
      });
    }
    if (source == "gallery") {
      final XFile? img = await picker.pickImage(
          source: ImageSource.gallery, // alternatively, use ImageSource.gallery
          imageQuality: 80);
      if (img == null) return;
      imgForApi = await img.readAsBytes();
      Uint8List imgWidget = await img.readAsBytes();
      setState(() {
        galleryWidget = InkWell(
            onTap: () {
              source = "gallery";
              takeSnapshot(source);
            },
            child: Image.memory(
              imgWidget,
              width: 150,
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      nameController.text = arguments["name"];
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
            children: [cameraWidget, galleryWidget],
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
            child: DropdownButton<String>(
              value: typeValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  typeValue = value!;
                  type = typesfromApi[types.indexOf(typeValue)];
                });
              },
              items: types.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: DropdownButton<String>(
              value: genderValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  genderValue = value!;
                  gender = gendersfromApi[genders.indexOf(genderValue)];
                });
              },
              items: genders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
                                    sizes.add("XS");
                                    setState(() {
                                      sizeCheckbox[0] = true;
                                    });
                                  } else {
                                    sizes.removeAt(sizes.indexOf("XS"));
                                    setState(() {
                                      sizeCheckbox[0] = false;
                                    });
                                  }
                                }),
                            const Text("XS (34)")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[1],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("S");
                                    setState(() {
                                      sizeCheckbox[1] = true;
                                    });
                                  } else {
                                    sizes.removeAt(sizes.indexOf("S"));
                                    setState(() {
                                      sizeCheckbox[1] = false;
                                    });
                                  }
                                }),
                            const Text("S (36)")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[2],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("M");
                                    setState(() {
                                      sizeCheckbox[2] = true;
                                    });
                                  } else {
                                    sizes.removeAt(sizes.indexOf("M"));
                                    setState(() {
                                      sizeCheckbox[2] = false;
                                    });
                                  }
                                }),
                            const Text("M (38)")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[3],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("L");
                                    setState(() {
                                      sizeCheckbox[3] = true;
                                    });
                                  } else {
                                    sizes.removeAt(sizes.indexOf("L"));
                                    setState(() {
                                      sizeCheckbox[3] = false;
                                    });
                                  }
                                }),
                            const Text("L (40)")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[4],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("XL");
                                    setState(() {
                                      sizeCheckbox[4] = true;
                                    });
                                  } else {
                                    sizes.removeAt(sizes.indexOf("XL"));
                                    setState(() {
                                      sizeCheckbox[4] = false;
                                    });
                                  }
                                }),
                            const Text("XL (42)")
                          ],
                        )
                      ]),
                ],
              ),
              Expanded(child: SizedBox()),
              Column(
                children: [
                  const Text("Cores"),
                  ElevatedButton(
                      onPressed: () {
                        ColorPicker();
                      },
                      child: Text("Cores"))
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
                  const Text("Novidade"),
                  Visibility(
                      child: Text(
                        "Erro, verifique todos os campos!",
                        style: TextStyle(color: Colors.red),
                      ),
                      visible: textVisible),
                ],
              )),
          Expanded(child: SizedBox()),
          ElevatedButton(
              onPressed: () {
                List colors = [];
                ApiColors.forEach((color) =>
                    colors.add(color.value.toRadixString(16).substring(2)));
                setState(() {
                  name = nameController.text;
                  stock = stockController.text;
                  price = priceController.text;
                  promotion = promotionController.text;
                  apiCall(
                      name,
                      typeValue,
                      double.parse(stock),
                      genderValue,
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
                "Submeter",
                style: TextStyle(fontSize: 24),
              )),
          ElevatedButton(
              onPressed: () {
                deleteCall(arguments["id"]);
              },
              child: const Text(
                "Eliminar",
                style: TextStyle(fontSize: 24),
              )),
        ],
      )),
    );
  }
}
