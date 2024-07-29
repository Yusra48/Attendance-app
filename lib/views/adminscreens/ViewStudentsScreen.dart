import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewStudentsScreen extends StatefulWidget {
  @override
  _ViewStudentsScreenState createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  List<String> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _students = prefs.getStringList('students') ?? [];
    });
  }

  Future<void> _addStudent(String student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _students.add(student);
    });
    await prefs.setStringList('students', _students);
  }

  Future<void> _deleteStudent(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _students.removeAt(index);
    });
    await prefs.setStringList('students', _students);
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddStudentDialog(
          onAdd: (student) {
            _addStudent(student);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showEditStudentDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditStudentDialog(
          student: _students[index],
          onUpdate: (updatedStudent) {
            setState(() {
              _students[index] = updatedStudent;
            });
            _updateStudentList();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _updateStudentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('students', _students);
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
          'View Students',
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
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_students[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteStudent(index),
            ),
            onTap: () => _showEditStudentDialog(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}


class AddStudentDialog extends StatelessWidget {
  final Function(String) onAdd;

  AddStudentDialog({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    return AlertDialog(
      title: Text('Add Student',style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      content: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Student Name'),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
           style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
          child: Text('Cancel',style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            onAdd(_controller.text);
            Navigator.of(context).pop();
          },
           style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
          child: Text('Add',style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ],
    );
  }
}


class EditStudentDialog extends StatelessWidget {
  final String student;
  final Function(String) onUpdate;

  EditStudentDialog({required this.student, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController(text: student);

    return AlertDialog(
      title: Text('Edit Student',style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      content: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Student Name'),
        ),
      ),
      actions: [
        ElevatedButton(
           style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel',style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        ElevatedButton(
           style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
          onPressed: () {
            onUpdate(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text('Update',style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ],
    );
  }
}
