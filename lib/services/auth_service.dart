class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Map<String, Map<String, dynamic>> _users = {};

  Map<String, dynamic>? currentUser;

  String? register(Map<String, dynamic> user) {
    if (_users.containsKey(user['email'])) {
      return "User exists";
    }
    _users[user['email']] = user;
    return null;
  }

  String? login(String email, String password) {
    if (!_users.containsKey(email)) return "User not found";

    if (_users[email]!['password'] != password) {
      return "Invalid password";
    }

    currentUser = _users[email];
    return null;
  }

  void logout() => currentUser = null;
}