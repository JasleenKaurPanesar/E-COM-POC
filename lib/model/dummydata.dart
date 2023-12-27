import 'package:e_commerce/model/product.dart';
import 'package:e_commerce/model/shop.dart';

class DummyShopList {
  static List<Shop> getShops() {
    return [
      Shop(
        name: 'Shop 1',
        photo: 'assets/images/shop-1.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
        latitude: 122.4175901, longitude: -40.0831136,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 1',
            photo: 'assets/images/product-1.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 2',
            photo: 'assets/images/product-2.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 2',
        photo: 'assets/images/shop-2.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
        latitude: 37.4284449, longitude: -122.0867102,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 3',
            photo: 'assets/images/product-3.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 4',
            photo: 'assets/images/product-4.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 3',
        photo: 'assets/images/shop-3.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
        latitude: 37.4251555, longitude: -122.0716367,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 5',
            photo: 'assets/images/product-5.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 6',
            photo: 'assets/images/product-6.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 4',
        photo: 'assets/images/shop-4.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
        latitude: 37.4199784, longitude: -122.0895953,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 7',
            photo: 'assets/images/product-7.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 8',
            photo: 'assets/images/product-8.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 5',
        photo: 'assets/images/shop-5.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
        latitude: 37.4294882, longitude: -122.0949024,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 9',
            photo: 'assets/images/product-9.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 10',
            photo: 'assets/images/product-10.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 6',
        photo: 'assets/images/shop-1.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
        latitude: 37.4237712, longitude: -122.0782217,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 11',
            photo: 'assets/images/product-11.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 12',
            photo: 'assets/images/product-5.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 7',
        photo: 'assets/images/shop-1.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
        latitude: 37.4158751, longitude: -122.0793692,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 13',
            photo: 'assets/images/product-1.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 14',
            photo: 'assets/images/product-2.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 7',
        photo: 'assets/images/shop-1.jpg',
        description: 'Description for Shop 1',
        address: '123 Main Street',
       latitude: 37.4183814, longitude: -122.0942065,
        owner: 'John Doe',
        products: [
          Product(
            name: 'Product 15',
            photo: 'assets/images/product-5.jpg',
            description: 'Description for Product 1',
            price: 19.99,
            quantity: 50,
          ),
          Product(
            name: 'Product 16',
            photo: 'assets/images/product-6.jpg',
            description: 'Description for Product 2',
            price: 29.99,
            quantity: 30,
          ),
        ],
      ),
      Shop(
        name: 'Shop 8',
        photo: 'assets/images/shop-2.jpg',
        description: 'Description for Shop 2',
        address: '456 Market Street',
        latitude: 37.4207473, longitude: -122.0916691,
        owner: 'Jane Doe',
        products: [
          Product(
            name: 'Product 17',
            photo: 'assets/images/product-3.jpg',
            description: 'Description for Product 3',
            price: 14.99,
            quantity: 40,
          ),
          Product(
            name: 'Product 18',
            photo: 'assets/images/product-5.jpg',
            description: 'Description for Product 4',
            price: 24.99,
            quantity: 20,
          ),
        ],
      ),
      // Add more shops as needed
    ];
  }
}

