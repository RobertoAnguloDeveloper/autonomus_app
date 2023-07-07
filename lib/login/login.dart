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
                'assets/image/nn.png',
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: licenseNumber,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
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
    return Builder(builder: (BuildContext context) {
      return ElevatedButton(
        onPressed: () async {
          var a1 = licenseNumber.text;
          var url = Uri.parse('http://10.0.2.2:5000/vehicle/get/$a1');
          print(url);
          try {
            var response = await http.get(url);
            print(jsonDecode(response.body));
            if (response.statusCode == 200) {
              String data = response.body.toString();
              print(data+"Me tiene que mandar para la otra pagina");
            } else {
              print("Por favor verifique su usuario y/o contraseña $response.statusCode");
              throw Exception("Fallo al cargar los datos");
            }
          } catch (e) {
            print('Ocurrió un error al realizar la solicitud: $e');
          }
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