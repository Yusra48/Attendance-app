import 'package:attendance_app/screens/SplashScreen.dart';
import 'package:attendance_app/services/auth-services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child:const MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
