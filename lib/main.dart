import 'package:project/pages/create_account.dart';
import 'package:project/pages/editprofile_page.dart';
import 'package:project/pages/editproduct_page.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/pages/profile_page.dart';
import 'package:project/pages/main_page.dart';
import 'package:project/pages/menu_page.dart';
import 'package:project/pages/unlogged_page.dart';
import 'package:project/pages/creation_page.dart';
import 'package:project/pages/item_page.dart';
import 'package:project/pages/cart_page.dart';
import 'package:project/pages/purchase_page.dart';
import 'package:flutter/material.dart';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      routes: {
        "/loginpage": (context) => const LoginPage(),
        "/createaccount": (context) => const CreateAccount(),
        "/mainpage": (context) => const MainPage(),
        "/unloggedpage": (context) => const UnloggedPage(),
        "/creationpage": (context) => const CreationPage(),
        "/profilepage": (context) => const ProfilePage(),
        "/editproductpage": (context) => const EditProductPage(),
        "/editprofilepage": (context) => const EditProfilePage(),
        "/menupage": (context) => const MenuPage(),
        "/cartpage": (context) => const CartPage(),
        "/itempage": (context) => const ItemPage(),
        "/purchasepage": (context) => const PurchasePage(),
      },
    );
  }
}
