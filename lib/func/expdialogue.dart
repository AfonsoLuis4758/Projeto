import 'package:flutter/material.dart';

Future<void> showMyDialog(context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sign in expirado.'),
                Text('Faça Login de novo para aceder a todas as features'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: const Text('Log In'),
                  onPressed: () {
                    Navigator.pushNamed(context, "/unloggedpage");
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      });
}
