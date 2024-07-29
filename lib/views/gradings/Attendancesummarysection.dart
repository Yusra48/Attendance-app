import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceSummaryScreen extends StatefulWidget {
  const AttendanceSummaryScreen({super.key});

  @override
  _AttendanceSummaryScreenState createState() => _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  int _totalLeaves = 0;
  int _totalPresents = 0;
  int _totalAbsents = 0;

  @override
  void initState() {
    super.initState();
    _loadAttendanceCounts();
  }

  Future<void> _loadAttendanceCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalLeaves = prefs.getInt('totalLeaves') ?? 0;
      _totalPresents = prefs.getInt('totalPresents') ?? 0;
      _totalAbsents = prefs.getInt('totalAbsents') ?? 0;
    });
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
          'Attendance Summary',
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
            Text('Total Leaves: $_totalLeaves'),
            Text('Total Presents: $_totalPresents'),
            Text('Total Absents: $_totalAbsents'),
          ],
        ),
      ),
    );
  }
}
