import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_event.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_state.dart';
import 'package:e_commerce/screens/shopDetail.dart';
import 'package:e_commerce/screens/create_shop_screen.dart'; // Import the CreateShop page

class CreateShopSuccessScreen extends StatefulWidget {
  final String uid;

  CreateShopSuccessScreen({required this.uid});

  @override
  _CreateShopSuccessScreenState createState() => _CreateShopSuccessScreenState();
}

class _CreateShopSuccessScreenState extends State<CreateShopSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user shops when the screen is initialized
    context.read<ShopsBloc>().add(FetchUserShops(uid: widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopsBloc, ShopsState>(
      listener: (context, state) {
        if (state is ShopsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Shops'),
        ),
        body: BlocBuilder<ShopsBloc, ShopsState>(
          builder: (context, state) {
            print("state ${state}");
            if (state is UserShopsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Your Shops as below. Add Shops here',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to CreateShop page when the button is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateShopScreen(uid: widget.uid)),
                        );
                      },
                      child: Text('Add Shop'),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.userShops.length,
                      itemBuilder: (context, index) {
                        final shop = state.userShops[index];
                        return GestureDetector(
                          onTap: () {
                            // Add your activity on card click here
                            // For example, you can navigate to another screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShopDetailScreen(shop: shop)),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  // Add the shop image on the left side of the card
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(shop.photo),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // Add shop details on the right side of the card
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shop.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(shop.address),
                                        SizedBox(height: 4),
                                        Text("Longitude: ${shop.longitude.toString()}"),
                                        SizedBox(height: 4),
                                        Text("Latitude: ${shop.latitude.toString()}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                 
                ],
              );
            } else {
              // You can customize the loading state as needed
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
