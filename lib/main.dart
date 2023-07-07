import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'CurrentLocation.dart';
import 'myInput.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(Autonomus_app());
}

class Autonomus_app extends StatelessWidget {
  const Autonomus_app({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LocationService locationService = LocationService();
  //final start = TextEditingController();
  final end = TextEditingController();
  bool isVisible = false;
  List<LatLng> routpoints = [LatLng(52.05884, -1.345583)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AUTONOMUS APP',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // myInput(
                //     controler: start, hint: 'Ingrese su direccion de Salida'),
                // SizedBox(
                //   height: 15,
                // ),
                myInput(
                    controler: end, hint: 'Ingrese su dirección de Destino'),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 21, 255),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        fixedSize: Size(100, 50)),
                    onPressed: () async {
                      List<double> startCoordinates =
                          await locationService.getCurrentLocation();
                      double startLatitude = startCoordinates[0];
                      double startLongitude = startCoordinates[1];

                      if (!end.text.contains(",")) {
                        end.text = end.text + ", Cartagena";
                      }

                      // List<Location> start_l =
                      //     await locationFromAddress(start.text);
                      List<Location> end_l =
                          await locationFromAddress(end.text);

                      var v1 = startLatitude;
                      var v2 = startLongitude;
                      var v3 = end_l[0].latitude;
                      var v4 = end_l[0].longitude;

                      var url = Uri.parse(
                          'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                      var response = await http.get(url);
                      print(response.body);
                      setState(() {
                        routpoints = [];
                        var router = jsonDecode(response.body)['routes'][0]
                            ['geometry']['coordinates'];
                        for (int i = 0; i < router.length; i++) {
                          var coordinates = router[i].toString();
                          coordinates = coordinates.replaceAll("[", "");
                          coordinates = coordinates.replaceAll("]", "");
                          var lat1 = coordinates.split(',');
                          var long1 = coordinates.split(",");
                          routpoints.add(LatLng(
                              double.parse(lat1[1]), double.parse(long1[0])));
                        }
                        isVisible = !isVisible;
                        print(routpoints);
                      });
                    },
                    child: Text('Ir', style: TextStyle(fontSize: 20.0))),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 500,
                  width: 400,
                  child: Visibility(
                    visible: isVisible,
                    child: FlutterMap(
                      options: MapOptions(
                        center: routpoints[0],
                        zoom: 13.0,
                        maxZoom: 25.0,
                        scrollWheelVelocity: 5.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: routpoints[0],
                              builder: (context) => Icon(
                                Icons.local_taxi,
                                weight: 20,
                                size: 50,
                                shadows: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(1.0),
                                      blurRadius: 5.0,
                                      offset: Offset(2.0, 2.0))
                                ],
                                color: Color.fromARGB(255, 0, 30, 255),
                              ),
                            ),
                            Marker(
                              point: routpoints[routpoints.length - 1],
                              builder: (context) => Icon(
                                Icons.adjust_rounded,
                                weight: 50,
                                shadows: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(1.0),
                                      blurRadius: 5.0,
                                      offset: Offset(2.0, 2.0))
                                ],
                                size: 60,
                                color: Color.fromARGB(255, 77, 255, 0),
                              ),
                            ),
                          ],
                        ),
                        PolylineLayer(
                          polylineCulling: false,
                          polylines: [
                            Polyline(
                                points: routpoints,
                                color: Color.fromARGB(255, 255, 0, 0),
                                strokeWidth: 7)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
