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
  List<double> start = [];
  List<double> endL = [];
  final end = TextEditingController();
  bool isVisible = false;
  List<LatLng> routpoints = [LatLng(52.05884, -1.345583)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Routing',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.grey[500],
      ),
      backgroundColor: Colors.grey[300],
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
                        backgroundColor: Colors.grey[500]),
                    onPressed: () async {
                      List<double> startCoordinates =
                          await locationService.getCurrentLocation();
                      start.addAll(startCoordinates);
                      double startLatitude = startCoordinates[0];
                      double startLongitude = startCoordinates[1];

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
                    child: Text('Ir')),
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
                        zoom: 10,
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
                              point: new LatLng(10.392133, -75.481015),
                              builder: (context) => Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                            ),
                            Marker(
                              point: new LatLng(10.372800, -75.456639),
                              builder: (context) => Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        PolylineLayer(
                          polylineCulling: false,
                          polylines: [
                            Polyline(
                                points: routpoints,
                                color: Colors.blue,
                                strokeWidth: 9)
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
