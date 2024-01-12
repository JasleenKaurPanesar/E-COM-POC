import 'package:bloc/bloc.dart';
import 'package:e_commerce/model/shop.dart';
import 'package:e_commerce/model/product.dart';
import 'shops_event.dart';
import 'shops_state.dart';

import 'package:e_commerce/blocs/shops_bloc/shop_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/helpers/reusable_widget.dart';



class ShopsBloc extends Bloc<ShopsEvent, ShopsState> {
  final _reloadController = StreamController<void>();

  ShopsBloc() : super(ShopsLoading()) {
    on<LoadShops>(_mapLoadShopsToState);
    on<FilterShops>(_mapFilterShopsToState);
    on<CreateShop>(_mapCreateShopToState);
    on<FetchUserShops>(_mapFetchUserShopsToState);
    on<AddProductEvent>(_mapAddProductToState);
    on<UpdateProductEvent>(_mapUpdateProductToState);
    on<UpdateProductIsShownEvent>(_mapUpdateProductIsShownToState);
  }


  Stream<void> get reloadStream => _reloadController.stream;

 
  void reloadShops() {
    _reloadController.add(null);

  }

  void dispose() {
    _reloadController.close();
  }

  Future<void> _mapLoadShopsToState(LoadShops event, Emitter<ShopsState> emit) async {
    try {
      List<Shop> shops = await ShopService.getAllShops();
      emit(ShopsLoaded(shops: shops));
    } catch (e) {
      emit(ShopsError(error: 'Error loading shops'));
    }
  }

 Future<void> _mapFilterShopsToState(FilterShops event, Emitter<ShopsState> emit) async {

  try {
  List<Shop> shops = await ShopService.getAllShops();

    shops=ShopService.getShopsInRadius(
      shops,
      event.userLocation,
      event.selectedRadius,
    );
    emit(ShopsLoaded(shops: shops));
  } catch (e) {
    emit(ShopsError(error: 'Error filtering shops'));
  }
}

Future<void> _mapCreateShopToState(CreateShop event, Emitter<ShopsState> emit) async {
  try {
    emit(CreateShopLoading());

   
    // await Future.delayed(Duration(seconds: 2));

    Shop createdShop = event.newShop;



    String photoURL = await uploadImageToStorage(event.newShop.photo, event.newShop.name.toLowerCase().replaceAll(" ", ""));
    // Update the shop photo URL in the createdShop object
     createdShop.photo = photoURL;
   
    // Add the new shop to the 'shops' field inside the user's document
    await FirebaseFirestore.instance.collection('users').doc(event.uid).update({
      'shops': FieldValue.arrayUnion([createdShop.name]),
    });

    // Add the new shop document under the 'shops' collection
    await FirebaseFirestore.instance.collection('shops').doc(createdShop.name.replaceAll(" ", "")).set(createdShop.toMap());

    // Fetch the updated user shops after creating a new shop
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userSnapshot = await usersCollection.doc(event.uid).get();

    if (userSnapshot.exists) {
      List<dynamic> shopsData = userSnapshot.get('shops') ?? [];
      List<String> userShops = shopsData.cast<String>().toList();

      List<Shop> shops = [];
      for (String shopId in userShops) {
        DocumentSnapshot shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
        if (shopSnapshot.exists) {
          Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

          // Ensure that the 'products' field is a list
          List<dynamic>? productsData = shopData['products'];

          // Check if productsData is a list
          List<Product> products = (productsData is List)
              ? productsData.map((productData) => Product.fromMap(productData)).toList()
              : [];

          Shop shop = Shop(
            name: shopData['name'],
            photo: shopData['photo'],
            description: shopData['description'],
            address: shopData['address'],
            latitude: shopData['latitude'],
            longitude: shopData['longitude'],
            owner: shopData['owner'],
            products: products,
          );

          shops.add(shop);
        }
      }

    _reloadController.add(null); // Trigger a reload
      emit(CreateShopSuccess());
      emit(UserShopsLoaded(userShops: shops));
    } else {
      print('User document not found for UID: ${event.uid}');
      emit(ShopsError(error: 'User document not found'));
    }
  } catch (e) {
    emit(CreateShopFailure(error: 'Failed to create shop. Please try again.'));
  }
}



  Future<void> _mapFetchUserShopsToState(FetchUserShops event, Emitter<ShopsState> emit) async {
    try {

      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      DocumentSnapshot userSnapshot = await usersCollection.doc(event.uid).get();

      if (userSnapshot.exists) {
        List<dynamic> shopsData = userSnapshot.get('shops') ?? [];
        List<String> userShops = shopsData.cast<String>().toList();

        // Fetch details for each shop
        List<Shop> shops = [];
        for (String shopId in userShops) {
          DocumentSnapshot shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
          if (shopSnapshot.exists) {
            Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

            // Ensure that the 'products' field is a list
            List<dynamic>? productsData = shopData['products'];

            // Check if productsData is a list
            List<Product> products = (productsData is List)
                ? productsData.map((productData) => Product.fromMap(productData)).toList()
                : [];

            Shop shop = Shop(
              name: shopData['name'],
              photo: shopData['photo'],
              description: shopData['description'],
              address: shopData['address'],
              latitude: shopData['latitude'],
              longitude: shopData['longitude'],
              owner: shopData['owner'],
              products: products,
            );

            shops.add(shop);
          }
        }

        emit(UserShopsLoaded(userShops: shops));
      } else {
       
        emit(ShopsError(error: 'User document not found'));
      }
    } catch (e) {
  
      emit(ShopsError(error: 'Error fetching user shops: $e'));
    }
  }

 Future<void> _mapAddProductToState(AddProductEvent event, Emitter<ShopsState> emit) async {

  try {
    // Fetch the current shop data
    DocumentSnapshot shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(event.shopId).get();

    if (shopSnapshot.exists) {
      Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

      // Ensure that the 'products' field is a list
      List<dynamic>? productsData = shopData['products'];

      // Check if productsData is a list
      List<Product> products = (productsData is List)
          ? productsData.map((productData) => Product.fromMap(productData)).toList()
          : [];

      // Add the new product to the list
      Product createProduct=event.newProduct;
      String photoURL = await uploadImageToStorage(event.newProduct.photo, event.newProduct.name.toLowerCase().replaceAll(" ", ""));
      createProduct.photo = photoURL;
      products.add(createProduct);

      // Update the shop data in Firestore
      await FirebaseFirestore.instance.collection('shops').doc(event.shopId).update({
        'products': products.map((product) => product.toMap()).toList(),
      });
    // Wait for a short duration (e.g., 1000 milliseconds) to allow the state to update
      await Future.delayed(const Duration(milliseconds: 1000));
      // Fetch the updated user shops after adding a new product
      List<Shop> updatedShops = await _fetchUserShops(event.uid);

      emit(AddProductSuccess(updatedShops: updatedShops));
      emit(UserShopsLoaded(userShops: updatedShops));
    } else {
      emit(ShopsError(error: 'Shop not found for ID: ${event.shopId}'));
    }
  } catch (e) {
    emit(ShopsError(error: 'Error adding product: $e'));
  }
}
Future<void> _mapUpdateProductToState(UpdateProductEvent event, Emitter<ShopsState> emit) async {
  try {
    // Fetch the current shop data
    DocumentSnapshot shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(event.shopId).get();

    if (shopSnapshot.exists) {
      Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

      // Ensure that the 'products' field is a list
      List<dynamic>? productsData = shopData['products'];

      // Check if productsData is a list
      List<Product> products = (productsData is List)
          ? productsData.map((productData) => Product.fromMap(productData)).toList()
          : [];

      // Find the product with the specified productId
      Product updatedProduct = products.firstWhere(
        (product) => product.name == event.name,
        orElse: () => Product(
          name: event.name,
          photo: '', // provide appropriate default values
          description: '',
          price: 0.0,
          quantity: 0,
          shopName: '',
        ),
      );

      // Update the quantity of the product
      updatedProduct.quantity = event.newQuantity;
      updatedProduct.price = event.newPrice;
      // Update the shop data in Firestore
      await FirebaseFirestore.instance.collection('shops').doc(event.shopId).update({
        'products': products.map((product) => product.toMap()).toList(),
      });

      // Fetch the updated user shops after updating the product
      List<Shop> updatedShops = await _fetchUserShops(event.uid);

      emit(UpdateProductSuccess(updatedShops: updatedShops));
      emit(UserShopsLoaded(userShops: updatedShops));
    } else {
      emit(ShopsError(error: 'Shop not found for ID: ${event.shopId}'));
    }
  } catch (e) {
    emit(ShopsError(error: 'Error updating product: $e'));
  }
}

Future<void> _mapUpdateProductIsShownToState(UpdateProductIsShownEvent event, Emitter<ShopsState> emit) async {
  try {
    // Fetch the current shop data
    DocumentSnapshot shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(event.shopId).get();

    if (shopSnapshot.exists) {
      Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

      // Ensure that the 'products' field is a list
      List<dynamic>? productsData = shopData['products'];

      // Check if productsData is a list
      List<Product> products = (productsData is List)
          ? productsData.map((productData) => Product.fromMap(productData)).toList()
          : [];

      // Find the product with the specified productId
      Product updatedProduct = products.firstWhere(
        (product) => product.name == event.name,
        orElse: () => Product(
          name: event.name,
          photo: '', // provide appropriate default values
          description: '',
          price: 0.0,
          quantity: 0,
          shopName: '',
        ),
      );

      // Update the quantity of the product
      updatedProduct.isShown = event.isShown;
     
      // Update the shop data in Firestore
      await FirebaseFirestore.instance.collection('shops').doc(event.shopId).update({
        'products': products.map((product) => product.toMap()).toList(),
      });

      // Fetch the updated user shops after updating the product
      List<Shop> updatedShops = await _fetchUserShops(event.uid);

      emit(UpdateProductSuccess(updatedShops: updatedShops));
      emit(UserShopsLoaded(userShops: updatedShops));
    } else {
      emit(ShopsError(error: 'Shop not found for ID: ${event.shopId}'));
    }
  } catch (e) {
    emit(ShopsError(error: 'Error updating product: $e'));
  }
}




  Future<List<Shop>> _fetchUserShops(String uid) async {
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(uid).get();

      if (userSnapshot.exists) {
        List<dynamic> shopsData = userSnapshot.get('shops') ?? [];
        List<String> userShops = shopsData.cast<String>().toList();

        List<Shop> shops = [];
        for (String shopId in userShops) {
          DocumentSnapshot shopSnapshot = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
          if (shopSnapshot.exists) {
            Map<String, dynamic> shopData = shopSnapshot.data() as Map<String, dynamic>;

            List<dynamic>? productsData = shopData['products'];
            List<Product> products = (productsData is List)
                ? productsData.map((productData) => Product.fromMap(productData)).toList()
                : [];

            Shop shop = Shop(
              name: shopData['name'],
              photo: shopData['photo'],
              description: shopData['description'],
              address: shopData['address'],
              latitude: shopData['latitude'],
              longitude: shopData['longitude'],
              owner: shopData['owner'],
              products: products,
            );

            shops.add(shop);
          }
        }

        return shops;
      } else {
        print('User document not found for UID: $uid');
        return [];
      }
    } catch (e) {
      print('Error fetching user shops for UID: $uid');
      return [];
    }
  }








}
