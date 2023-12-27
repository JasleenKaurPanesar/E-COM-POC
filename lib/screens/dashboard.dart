import 'package:e_commerce/model/dummydata.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/screens/shopDetail.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Shop> shops =DummyShopList.getShops();
  late Position _userLocation;

  @override
  void initState() {
    super.initState();
    _initUserLocation();
  }

  Future<void> _initUserLocation() async {
    try {
      Position location = await _getUserLocation();
      setState(() {
        _userLocation = location;
      });
    } catch (e) {
      // Handle location retrieval error
      print("Error getting user location: $e");
    }
  }

  Future<Position> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      // Handle location retrieval error
      print("Error getting user location: $e");
      return Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }
  }

  List<Shop> _getShopsInRadius(double maxDistanceKm) {
  List<Shop> nearbyShops = shops.where((shop) {
    double distance = Geolocator.distanceBetween(
      _userLocation.latitude,
      _userLocation.longitude,
      shop.latitude,
      shop.longitude,
    );

    return distance / 1000 <= maxDistanceKm; // Convert to kilometers
  }).toList();

  nearbyShops.sort((a, b) {
    double distanceA = Geolocator.distanceBetween(
      _userLocation.latitude,
      _userLocation.longitude,
      a.latitude,
      a.longitude,
    );

    double distanceB = Geolocator.distanceBetween(
      _userLocation.latitude,
      _userLocation.longitude,
      b.latitude,
      b.longitude,
    );

    return distanceA.compareTo(distanceB);
  });

  return nearbyShops;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop List'),
      ),
      body: FutureBuilder(
        future: _getUserLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // User location obtained, now display the list of shops
            List<Shop> filteredShops = _getShopsInRadius(10); // Specify the distance here

            return ListView.builder(
              itemCount: filteredShops.length,
              itemBuilder: (context, index) {
                double distance = Geolocator.distanceBetween(
                  _userLocation.latitude,
                  _userLocation.longitude,
                  filteredShops[index].latitude,
                  filteredShops[index].longitude,
                );

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.blue),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage(filteredShops[index].photo),
                    ),
                    title: Text(filteredShops[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(filteredShops[index].address),
                        Text('Distance: ${(distance / 1000).toStringAsFixed(2)}  km'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopDetailScreen(
                            shop: filteredShops[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            // Loading indicator while getting user location
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
