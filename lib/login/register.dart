import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  static String id = "resgiter_page";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final numberId = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
          title: const Text(
          'REGISTRAR DE VEHICULOS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),  
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: Image.asset(
              'assets/image/logo1.png',
              height: 200.0,
            )),
            SizedBox(
              height: 15.0,
            ),
            _userTextField(),
            SizedBox(
              height: 15.0,
            ),
            _passwordTextField(),
            SizedBox(
              height: 15.0,
            ),
            _bottonRegister(),
          ],
        ),
      ),
    ));
  }

  Widget _userTextField() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: numberId,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            icon: Icon(Icons.airport_shuttle_outlined,color:Colors.blue),
            hintText: 'License number',
            labelText: 'License number',
             hintStyle: TextStyle(
              color: Color.fromARGB(255, 228, 225, 225), 
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            focusColor: Color.fromARGB(255, 241, 233, 233),
            
          ),
        ),
      );
    });
  }

  Widget _passwordTextField() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: password,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            icon: Icon(Icons.lock,color:Colors.blue ),
            hintText: 'Password',
            labelText: 'Password',
           hintStyle: TextStyle(
            color: Color.fromARGB(255, 228, 225, 225), // Cambia a tu color deseado para hintText
          ),
          labelStyle: TextStyle(
            color: Colors.blue,
          ),
           
            focusColor: Color.fromARGB(255, 241, 233, 233),
          ),
        ),
      );
    });
  }

  Widget _bottonRegister() {
    return Builder(builder: (BuildContext context) {
      return ElevatedButton(
          onPressed: () async {
            var a1 = numberId.text;
            var a2 = password.text;
            var url = Uri.parse('http://10.0.2.2:5000/vehicle/create/');

            try {
              var data = {'license_number': a1, 'password': a2};
              var response = await http.post(url, body: data);
              //print(response);
              if (response.statusCode == 200) {
                String data = response.body.toString();
                //print("Usuario creado con exito " + data);
              } else {
                print("Por favor verifique su usuario y/o contraseña");
                throw Exception("Fallo al cargar los datos");
              }
            } catch (e) {
              print('Error al intentar crear: $e');
            }
          },
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: const Text(
                'Registrar',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )));
    });
  }
}
