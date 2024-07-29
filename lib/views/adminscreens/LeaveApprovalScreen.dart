import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveApprovalScreen extends StatefulWidget {
  const LeaveApprovalScreen({super.key});

  @override
  _LeaveApprovalScreenState createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  List<String> _leaveRequests = [];

  @override
  void initState() {
    super.initState();
    _loadLeaveRequests();
  }

  Future<void> _loadLeaveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _leaveRequests = prefs.getStringList('leaveRequests') ?? [];
    });
  }

  Future<void> _approveLeave(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String request = _leaveRequests[index];
    _leaveRequests.removeAt(index);
    await prefs.setStringList('leaveRequests', _leaveRequests);
    setState(() {});

    _showSnackBar('Leave request accepted: $request');
  }

  Future<void> _rejectLeave(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String request = _leaveRequests[index];
    _leaveRequests.removeAt(index);
    await prefs.setStringList('leaveRequests', _leaveRequests);
    setState(() {});

    _showSnackBar('Leave request rejected: $request');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
          'Leave Approval Screen',
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
      body: _leaveRequests.isEmpty
          ? Center(child: Text('No leave requests to approve.'))
          : ListView.builder(
              itemCount: _leaveRequests.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      _leaveRequests[index],
                      style: GoogleFonts.bonaNova(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _approveLeave(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => _rejectLeave(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
