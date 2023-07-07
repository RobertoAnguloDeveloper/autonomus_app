import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final start = TextEditingController();
  final end = TextEditingController();
  bool isVisible = false;
  List<LatLng> routpoints = [LatLng(52.05884, -1.345583)];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Autonomus App")),
        backgroundColor: Colors.white,
        body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
                    onPressed: () async{
                      List<Location> start_l = await locationFromAddress(start.text);
                      List<Location> end_l = await locationFromAddress(end.text);

                      var v1 = start_l[0].latitude;
                      var v2 = start_l[0].longitude;
                      var v3 = end_l[0].latitude;
                      var v4 = end_l[0].longitude;

                      
                      var url = Uri.parse('http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                      var response = await http.get(url);
                      print(response.body);
                      setState(() {                                                     
                        routpoints = [];
                        var ruter = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
                        for(int i=0; i< ruter.length; i++){
                          var reep = ruter[i].toString();
                          reep = reep.replaceAll("[","");
                          reep = reep.replaceAll("]","");
                          var lat1 = reep.split(',');
                          var long1 = reep.split(",");
                          routpoints.add(LatLng( double.parse(lat1[1]), double.parse(long1[0])));
                        }
                        isVisible = !isVisible;
                        print(routpoints);
                      });
                    },
                    child: Text('Press')),
                SizedBox(height: 10,),
                SizedBox(
                  height: 500,
                  width: 400,
                  child: Visibility(
                    visible: isVisible,
                    child: FlutterMap(options:
                        MapOptions(
                          center: routpoints[0],
                          zoom: 10,
                        ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        PolylineLayer(
                          polylineCulling: false,
                          polylines: [
                            Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
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