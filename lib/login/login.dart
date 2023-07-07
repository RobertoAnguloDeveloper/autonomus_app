import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static String id = "login_page";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final licenseNumber = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                'assets/image/flutter_logo.png',
                height: 250.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            _userTextField(),
            SizedBox(
              height: 15.0,
            ),
            _passwordTextField(),
            SizedBox(
              height: 20.0,
            ),
            _bottonLogin(),
          ],
        )),
      ),
    );
  }

  Widget _userTextField() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: licenseNumber,
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.airport_shuttle_outlined),
            hintText: 'License number',
            labelText: 'License number',
          ),
          onChanged: (value) {},
        ),
      );
    });
  }

  Widget _passwordTextField() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: password,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock_person),
            hintText: 'Password',
            labelText: 'Password',
          ),
        ),
      );
    });
  }

  Widget _bottonLogin() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return ElevatedButton(
        onPressed: () {
          //Color.alphaBlend(Colors.blue, Colors.white12);
          fetchData(licenseNumber);
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: const Text(
              'Iniciar Sesion',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            )),
      );
    });
  }
}

void fetchData(licenseNumber) async {
  String url = 'http://127.0.0.1:5000/vehicles/get/$licenseNumber';
  final response = await http.get(Uri.parse(url));
  print(jsonDecode(response.body));
  if (response.statusCode == 200) {
    String data = response.body;
    print(data);
  } else {
    throw Exception("Fallo al cargar los datos");
  }
}
