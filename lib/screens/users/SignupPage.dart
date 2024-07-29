import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance_app/views/HomeView.dart';
import 'package:attendance_app/screens/users/LoginPage.dart'; 
import 'package:google_fonts/google_fonts.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  Future<void> _registerUser() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('All fields are required');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> storedEmails = prefs.getStringList('emails') ?? [];
      List<String> storedPasswords = prefs.getStringList('passwords') ?? [];

      if (storedEmails.contains(email)) {
        _showSnackBar('An account already exists for that email');
        return;
      }

      storedEmails.add(email);
      storedPasswords.add(password);

      await prefs.setStringList('emails', storedEmails);
      await prefs.setStringList('passwords', storedPasswords);

      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHomeView()),
      );
    } catch (e) {
      print('Registration Error: $e');
      _showSnackBar('Registration Failed');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.black, size: 40),
        title: Text(
          'Sign Up',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create an account',
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  fontSize: 30,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Text(
                'Please enter your information to create an account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              hintText: 'Enter Your Email address',
              isObscure: false,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              hintText: 'Enter Your Password',
              isObscure: true,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Your Password',
              isObscure: true,
            ),
            const SizedBox(height: 10),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _registerUser,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Sign up with',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Google.png', height: 30),
                const SizedBox(width: 20),
                Image.asset('assets/Apple.png', height: 30),
              ],
            ),
            const SizedBox(height: 5),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
  }) {
    final themeData = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
