import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendance_app/services/auth-services.dart';
import 'package:attendance_app/views/HomeView.dart';
import 'package:attendance_app/screens/users/SignupPage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
          size: 40,
        ),
        title: Text(
          'Sign In',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  fontSize: 30,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Text(
                'Please enter your email address and password to log in',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              hintText: 'Enter Your Email address',
              isObscure: false,
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              hintText: 'Enter Your Password',
              isObscure: _obscurePassword,
            ),
            SizedBox(height: 5),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color:Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _loginUser(context, authService),
                child: Text(
                  'Sign In',
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Sign in with',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Google.png', height: 40),
                SizedBox(width: 20),
                Image.asset('assets/Apple.png', height: 40),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  'Not Registered Yet? Sign Up',
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

  Future<void> _loginUser(BuildContext context, AuthService authService) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and Password are required')),
      );
      return;
    }

    try {
      bool success = await authService.signIn(email, password);

      if (success) {
        _emailController.clear();
        _passwordController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomeView()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Invalid email or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }
}
