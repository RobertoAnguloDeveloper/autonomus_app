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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child:
                  Image.asset('assets/image/flutter_logo.png',height: 250.0,),
                ),
            SizedBox(height: 15.0,),
            _userTextField(),
            SizedBox(height: 15.0,),
            _passwordTextField(),
            SizedBox(height: 20.0,),
            _bottonLogin(),
          ],
        )),
      ),
    );
  }

  Widget _userTextField() {
    final licenseNumber = TextEditingController();

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

    final password = TextEditingController();

    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller:password,
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
          Color.alphaBlend(Colors.blue, Colors.white12);
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Iniciar Sesion',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            )),
      );
    });
  }
}
