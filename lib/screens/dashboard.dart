import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:e_commerce/blocs/shops_bloc/shops.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_state.dart';
import 'package:e_commerce/blocs/shops_bloc/shop_service.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/screens/shop_detail.dart';
import 'package:e_commerce/reusable_widget/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart'; // Import CartBloc

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  double selectedRadius = 15.0; // Default radius
  late ShopsBloc shopsBloc;
StreamSubscription _reloadSubscription = StreamController().stream.listen((_) {});
late Position _userLocation = Position(
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
  late CartBloc cartBloc; // Declare CartBloc

 

@override
  void initState() {
    super.initState();
    shopsBloc = context.read<ShopsBloc>();
    _initUserLocation();
    cartBloc = CartBloc(shopsBloc: shopsBloc);

    // Make sure you are not listening to _reloadSubscription elsewhere
    // ignore: prefer_conditional_assignment
    if(_reloadSubscription == null){
    _reloadSubscription = shopsBloc.reloadStream.listen((_) {
      shopsBloc.add(LoadShops());
    });}
  }

  @override
  void dispose() {
    _reloadSubscription?.cancel();
    super.dispose();
  }
  Future<void> _initUserLocation() async {
    try {
      _userLocation = await _getUserLocation();
      // Dispatch the LoadShops event to initiate loading shops
      print("user location ${_userLocation}");
      shopsBloc.add(LoadShops());
    } catch (e) {
      // Handle location  error
      print("Error getting user location: $e");
    }
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
      appBar: const CustomAppBar(title:"Shops List"),
      body: BlocListener<ShopsBloc, ShopsState>(
        listener: (context, state) {
    
        },
        child: BlocBuilder<ShopsBloc, ShopsState>(
          builder: (context, state) {
            if (state is ShopsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ShopsLoaded) {
             
              List<Shop> shops = state.shops;
              shops=ShopService.getShopsInRadius(shops, _userLocation, selectedRadius);
             
              if (shops.isEmpty) {
                return const Center(child: Text("Shop not found"));
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Filter Shops by distance"),
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
                            
                            shopsBloc.add(FilterShops(userLocation: _userLocation, selectedRadius: value));
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
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.blue),
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
                            trailing: const Icon(Icons.arrow_forward),
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
              );
            } else if (state is ShopsError) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
