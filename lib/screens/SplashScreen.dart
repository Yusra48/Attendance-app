import 'package:attendance_app/screens/Admin/adminloginPanel.dart';
import 'package:attendance_app/screens/users/LoginPage.dart'; 
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  void navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/attendance.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 200, color: Colors.red);
              },
            ),
            SizedBox(height: 24),
            Text(
              'Attendance App',
              style: GoogleFonts.bonaNova(
                textStyle: TextStyle(
                  fontSize: 35,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 64),
            _buildLoginButton(
              icon: Icons.login,
              label: 'Student Login',
              onPressed: () => navigateToPage(LoginPage()),
            ),
            SizedBox(height: 30),
            _buildLoginButton(
              icon: Icons.admin_panel_settings,
              label: 'Admin Login',
              onPressed: () => navigateToPage(AdminLoginScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
