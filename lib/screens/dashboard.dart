import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:e_commerce/providers/shopsProvider.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/screens/shopDetail.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/cartProvider.dart'; // Import CartProvider
import 'package:e_commerce/utils/customAppBar.dart';
import 'dart:async';
class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Shop> shops = [];
  late Position _userLocation;
  var shopNotFound=false;
  double selectedRadius = 15.0; // Default radius

 


  @override
  void initState() {
    super.initState();
    _initUserLocation();
  }

Future<void> _initUserLocation() async {
    try {
      _userLocation = await _getUserLocation();
      await _loadShops();
  
    } catch (e) {
      // Handle location retrieval error
      print("Error getting user location: $e");
    
    }
  }


  Future<void> _loadShops() async {

    ShopProvider shopProvider = context.read<ShopProvider>();
    await shopProvider.initializeShops();

    setState(() {
      shops = shopProvider.getShopsInRadius(_userLocation, selectedRadius);
      if(shops.length==0){
        shopNotFound=true;
      }
      // shops=shopProvider.shops;
    });
  }

  Future<Position> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Position ${position}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Shops List',
        onLogout: () {
          // Implement your logout logic here
          // For example, you can use Navigator to navigate to the login screen
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
      body: shops.isEmpty && !shopNotFound
          ? Center(child: CircularProgressIndicator())
         : shops.isEmpty && shopNotFound?
          Center(child:Text("Shop not found"))
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Filter Shops by distance"),
                    DropdownButton<double>(
                      value: selectedRadius,
                      items: [1.0, 10.0, 15.0].map<DropdownMenuItem<double>>((double value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text('$value km'),
                        );
                      }).toList(),
                      onChanged: (double? value) {
                        if (value != null) {
                          setState(() {
                            selectedRadius = value;
                            shops = context.read<ShopProvider>().getShopsInRadius(_userLocation, selectedRadius);
                          });
                        }
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      double distance = Geolocator.distanceBetween(
                        _userLocation.latitude,
                        _userLocation.longitude,
                        shops[index].latitude,
                        shops[index].longitude,
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
                            backgroundImage: NetworkImage(shops[index].photo),
                          ),
                          title: Text(shops[index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shops[index].address),
                              Text(
                                'Distance: ${(distance / 1000).toStringAsFixed(2)} km',
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShopDetailScreen(
                                  shop: shops[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
