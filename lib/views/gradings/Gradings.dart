import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradingScreen extends StatefulWidget {
  const GradingScreen({super.key});

  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  int _attendanceDays = 0;
  String _grade = '';
  final TextEditingController _emailController = TextEditingController();

  void _calculateGrade() {
    if (_attendanceDays >= 26) {
      _grade = 'A';
    } else if (_attendanceDays >= 21) {
      _grade = 'B';
    } else if (_attendanceDays >= 16) {
      _grade = 'C';
    } else if (_attendanceDays >= 10) {
      _grade = 'D';
    } else {
      _grade = 'F';
    }
    setState(() {});
  }

  Future<void> _saveGrade() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? gradesList = prefs.getStringList('grades') ?? [];
    final email = _emailController.text;
    if (email.isNotEmpty) {
      gradesList.add('$email:$_grade');
      await prefs.setStringList('grades', gradesList);
      _emailController.clear();
      Navigator.pop(context);
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
          'Grading',
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Student Email',
                hintText: 'Enter student email',
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
              TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                hintText: 'Enter student name',
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Attendance Days',
                hintText: 'Enter number of days',
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                _attendanceDays = int.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateGrade,
                style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
              child: Text(
                'Calculate Grade',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGrade,
                style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
              child: Text(
                'Save Grade',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Grade: $_grade',style: GoogleFonts.bonaNova(
           textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),),
          ],
        ),
      ),
    );
  }
}
