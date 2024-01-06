class Product {
  String name;
  String photo;
  String description;
  double price;
  int quantity;
  String shopName;
  bool isShown; // New field

  Product({
    required this.name,
    required this.photo,
    required this.description,
    required this.price,
    required this.quantity,
    required this.shopName,
    this.isShown = true, // Default value
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photo': photo,
      'description': description,
      'price': price,
      'quantity': quantity,
      'shopName': shopName,
      'isShown': isShown,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      photo: map['photo'],
      description: map['description'],
      price: (map['price'] is int) ? map['price'].toDouble() : map['price'],
      quantity: map['quantity'],
      shopName: map['shopName'],
      isShown: map['isShown'] ?? true, // Default value if not present in the map
    );
  }
}
