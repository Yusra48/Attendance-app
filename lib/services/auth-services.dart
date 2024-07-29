import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Map<String, String> _users = {
    'test@example.com': 'password123',
    'user@gmail.com': '098765',
    'usertest@gmail.com': '123456',
    'grimUser@gmail.com': 'poiuyt',
    'test@gmail.com': 'qwerty',
  };

  Future<bool> signIn(String email, String password) async {
    if (_users.containsKey(email) && _users[email] == password) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    if (!_users.containsKey(email)) {
      _users[email] = password;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }
}
