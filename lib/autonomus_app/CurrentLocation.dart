import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<List<double>> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;

    return [latitude, longitude];
  }
}
