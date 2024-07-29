import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthService {
  final Map<String, String> _users = {
    'testuser@example.com': 'password123',
    'exampleuser@gmail.com': '098765',
    'johndoe@gmail.com': '123456',
    'grimrepear@gmail.com': 'poiuyt',
    'example@gmail.com': 'qwerty',
  };

  Future<bool> signIn(String email, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (_users.containsKey(email) && _users[email] == password) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        return true;
      }
      return false;
    } catch (e) {
      print('Error during sign-in: $e');
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      if (!_users.containsKey(email)) {
        _users[email] = password;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        return true;
      }
      return false;
    } catch (e) {
      print('Error during sign-up: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userEmail');
    } catch (e) {

      print('Error during sign-out: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<String?> getUserEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('userEmail');
    } catch (e) {

      print('Error retrieving user email: $e');
      return null;
    }
  }
}
