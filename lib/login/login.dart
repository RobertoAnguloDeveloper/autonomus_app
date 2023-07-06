import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String id = "login_page";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          children: [
            Image.asset('image/logo.png'),
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
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.airport_shuttle_outlined),
            hintText: 'Digite la placa',
            labelText: 'placa del vehiculo',
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
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.password),
            hintText: 'Digite password',
            labelText: 'Password',
          ),
          onChanged: (value) {},
        ),
      );
    });
  }

 _bottonLogin() {
    
  }
}
