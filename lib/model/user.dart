class User {
  final String id;
  final String username;
  final String email;
  final String password; // Only used for signup
  final String role; // Only used for signup

  User({
    required this.id,
    required this.username,
    required this.email,
    this.password = '', // Default empty string for login
    this.role = '', // Default empty string for login
  });
}
