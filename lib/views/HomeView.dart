import 'package:attendance_app/services/auth-services.dart';
import 'package:attendance_app/views/gradings/Attendancesummarysection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  _UserHomeViewState createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  bool _isPresent = false;
  List<String> _markedDates = [];
  String _userEmail = "Loading...";
  File? _profileImage;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _checkAttendanceStatus();
  }

  Future<void> _loadUserEmail() async {
    AuthService authService = AuthService();
    String? email = await authService.getUserEmail();
    setState(() {
      _userEmail = email ?? "Not logged in";
    });
  }

  Future<void> _checkAttendanceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = _getFormattedDate(DateTime.now());
    _markedDates = prefs.getStringList('marked_dates') ?? [];
    setState(() {
      _isPresent = _markedDates.contains(today);
    });
  }

  Future<void> _markAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = _getFormattedDate(DateTime.now());

    if (_markedDates.contains(today)) {
      _showSnackBar('You have already marked your attendance for today.');
      return;
    }

    _markedDates.add(today);
    await prefs.setStringList('marked_dates', _markedDates);
    setState(() {
      _isPresent = true;
    });
    _showSnackBar('Attendance marked as present.');
  }

  Future<void> _showLeaveRequestDialog() async {
    final startDateController = TextEditingController(text: _getFormattedDate(DateTime.now()));
    final endDateController = TextEditingController(text: _getFormattedDate(DateTime.now().add(const Duration(days: 1))));
    final reasonController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Request', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDateTextField(startDateController, 'Start Date (YYYY-MM-DD)'),
            _buildDateTextField(endDateController, 'End Date (YYYY-MM-DD)'),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final startDateStr = startDateController.text;
              final endDateStr = endDateController.text;
              final reasonText = reasonController.text;

              if (_validateDate(startDateStr) && _validateDate(endDateStr)) {
                final parsedStartDate = DateTime.tryParse(startDateStr);
                final parsedEndDate = DateTime.tryParse(endDateStr);

                if (parsedStartDate != null && parsedEndDate != null) {
                  _sendLeaveRequest(parsedStartDate, parsedEndDate, reasonText);
                  Navigator.of(context).pop();
                } else {
                  _showSnackBar('Invalid date format. Please use YYYY-MM-DD.');
                }
              } else {
                _showSnackBar('Invalid date format. Please use YYYY-MM-DD.');
              }
            },
            child: const Text('Submit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
        ],
      ),
    ).whenComplete(() {
      startDateController.dispose();
      endDateController.dispose();
      reasonController.dispose();
    });
  }

  Future<void> _sendLeaveRequest(DateTime startDate, DateTime endDate, String reason) async {
    if (startDate.isAfter(endDate)) {
      _showSnackBar('End date cannot be before start date.');
      return;
    }

    if (reason.isEmpty) {
      _showSnackBar('Reason cannot be empty.');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> leaveRequests = prefs.getStringList('leaveRequests') ?? [];
    String request = 'From: ${_formatDate(startDate)} To: ${_formatDate(endDate)} Reason: $reason';
    leaveRequests.add(request);
    await prefs.setStringList('leaveRequests', leaveRequests);

    _showSnackBar('Leave request submitted successfully.');
    Navigator.pop(context); 
  }

  Future<void> _showAttendanceCalendar() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attendance Calendar', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
        content: SizedBox(
          height: 400,
          width: 300,
          child: TableCalendar(
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(decoration: BoxDecoration(color: Colors.blue)),
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (_markedDates.contains(_getFormattedDate(date))) {
                  return const Positioned(
                    bottom: 1,
                    right: 1,
                    child: Icon(Icons.check_circle, color: Colors.blue, size: 16),
                  );
                }
                return null;
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(onPressed: () { Navigator.of(context).pop(); _pickImage(); }, child: const Text('Gallery')),
          TextButton(onPressed: () { Navigator.of(context).pop(); _takePhoto(); }, child: const Text('Camera')),
          TextButton(onPressed: () { Navigator.of(context).pop(); _uploadFromUrl(); }, child: const Text('Upload from URL')),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profileImageUrl = null;
      });
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? takenFile = await picker.pickImage(source: ImageSource.camera);

    if (takenFile != null) {
      setState(() {
        _profileImage = File(takenFile.path);
        _profileImageUrl = null;
      });
    }
  }

  Future<void> _uploadFromUrl() async {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Image URL'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(labelText: 'Image URL'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final url = urlController.text.trim();
              if (url.isNotEmpty) {
                try {
                  final response = await http.get(Uri.parse(url));
                  if (response.statusCode == 200) {
                    setState(() {
                      _profileImage = null;
                      _profileImageUrl = url;
                    });
                  } else {
                    _showSnackBar('Failed to load image from URL.');
                  }
                } catch (e) {
                  _showSnackBar('Invalid URL or network error.');
                }
              }
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueGrey,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!) as ImageProvider
                    : null,
            child: _profileImage == null && _profileImageUrl == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          Positioned(
            right: 10,
            bottom: -4,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                onPressed: _showImageSourceDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.datetime,
      onChanged: (value) {
        if (!_validateDate(value)) {
          _showSnackBar('Invalid date format.');
        }
      },
    );
  }

  bool _validateDate(String dateStr) {
    try {
      DateTime.parse(dateStr);
      return true;
    } catch (e) {
      return false;
    }
  }

  String _getFormattedDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  String _formatDate(DateTime date) {
    return _getFormattedDate(date);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 40),
        title: Text('User Panel', style: GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileImage(),
              const SizedBox(height: 20),
              Text(_userEmail, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              _buildActionButton(
                onPressed: _markAttendance,
                text: _isPresent ? 'Attendance Already Marked' : 'Mark Attendance',
                color: _isPresent ? Colors.blueGrey : Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                onPressed: _showAttendanceCalendar,
                text: 'View Attendance',
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                onPressed: _showLeaveRequestDialog,
                text: 'Mark Leave',
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceSummaryScreen()));
                },
                text: 'Attendance Summary',
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
}
