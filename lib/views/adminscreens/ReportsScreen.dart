import 'package:attendance_app/views/gradings/Gradings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<String> _gradesList = [];

  Future<void> _generateReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> grades = prefs.getStringList('grades') ?? [];
    setState(() {
      _gradesList = grades;
    });
  }

  @override
  void initState() {
    super.initState();
    _generateReport(); 
  }

  Future<void> _navigateToGradingScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GradingScreen()),
    );
    _generateReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
          size: 30,
        ),
        title: Text(
          'Report Screen',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              fontSize: 24,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateRange(),
            SizedBox(height: 20),
            _buildGenerateReportButton(),
            SizedBox(height: 20),
            _buildGradesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From: ${_formatDate(_startDate)}',
          style: GoogleFonts.bonaNova(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          'To: ${_formatDate(_endDate)}',
          style: GoogleFonts.bonaNova(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton() {
    return ElevatedButton(
      onPressed: _navigateToGradingScreen, 
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Generate Report',
        style: GoogleFonts.bonaNova(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGradesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _gradesList.length,
        itemBuilder: (context, index) {
          final gradeData = _gradesList[index].split(':');
          final email = gradeData[0];
          final grade = gradeData[1];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            title: Text(
              email,
              style: GoogleFonts.bonaNova(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            subtitle: Text(
              'Grade: $grade',
              style: GoogleFonts.bonaNova(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
