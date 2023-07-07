import 'package:autonomus_app/login/login.dart';
import 'package:autonomus_app/login/register.dart';
import 'package:flutter/material.dart';
import 'autonomus_app/AutonomusApp.dart';

void main() {
  runApp(const main_app());
}

class main_app extends StatelessWidget {
  const main_app({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      initialRoute: RegisterPage.id,
      //initialRoute: LoginPage.id,
      routes: {
        RegisterPage.id:(context) => RegisterPage(),
        //LoginPage.id:(context) => LoginPage(),
      },
    );
  }
}