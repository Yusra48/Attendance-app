import 'package:attendance_app/screens/Admin/adminloginPanel.dart';
import 'package:attendance_app/views/adminscreens/LeaveApprovalScreen.dart';
import 'package:attendance_app/views/adminscreens/ReportsScreen.dart';
import 'package:attendance_app/views/adminscreens/ViewStudentsScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isAdminLoggedIn');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AdminLoginScreen()),
      );
    } catch (e) {
      print('Logout Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
          size: 40,
        ),
        title: Text(
          'Admin Panel',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildElevatedButton(
              context,
              'View Students',
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ViewStudentsScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildElevatedButton(
              context,
              'Generate Reports',
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ReportsScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildElevatedButton(
              context,
              'Leave Approval',
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LeaveApprovalScreen()),
              ),
            ),
            const SizedBox(height: 32),
            _buildElevatedButton(
              context,
              'Logout',
              _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
