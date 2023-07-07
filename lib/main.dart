import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'CurrentLocation.dart';
import 'MapCard.dart';
import 'myInput.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const Autonomus_app());
}

class Autonomus_app extends StatelessWidget {
  const Autonomus_app({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  double duration = 0.0, distance = 0.0;
  List<LatLng> routpoints = [const LatLng(0.0, 0.0)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 21, 255),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        fixedSize: Size(100, 50)),
                    onPressed: () async {
                      setState(() {
                        isVisible = false;
                      });

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Dialog(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
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

                      try {
                        var url = Uri.parse(
                            'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                        var response = await http.get(url);
                        var url2 = Uri.parse(
                            'http://10.0.2.2:5000/vehicles/');
                        var response2 = await http.get(url2);
                        print(response2.body);
                        print(response.body);

                        setState(() {
                          routpoints = [];
                          duration = (jsonDecode(response.body)['routes'][0]
                                  ['legs'][0]['duration']) /
                              60;
                          distance = (jsonDecode(response.body)['routes'][0]
                              ['legs'][0]['distance']);
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
                          isVisible = true;
                          print(routpoints);
                        });
                      } catch (error) {
                        print('Error: $error');
                      }

                      Navigator.of(context).pop();
                    },
                    child: const Text('Ir', style: TextStyle(fontSize: 20.0))),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 500,
                  width: 400,
                  child: Visibility(
                    visible: isVisible,
                    child: FlutterMap(
                      options: MapOptions(
                        center:
                            routpoints[((routpoints.length - 1) / 2).toInt()],
                        zoom: 15.0,
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
                                      offset: Offset(1.0, 3.0),
                                      spreadRadius: 20.0)
                                ],
                                color: const Color.fromARGB(255, 255, 247, 0),
                              ),
                            ),
                            Marker(
                              rotate: true,
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
                                color: const Color.fromARGB(255, 51, 255, 0),
                              ),
                            ),
                          ],
                        ),
                        PolylineLayer(
                          polylineCulling: false,
                          polylines: [
                            Polyline(
                                points: routpoints,
                                color: const Color.fromARGB(255, 255, 0, 0),
                                strokeWidth: 7)
                          ],
                        ),
                        MapCard(double.parse(duration.toStringAsFixed(2)),
                            double.parse(distance.toStringAsFixed(2)))
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
