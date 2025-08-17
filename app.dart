//app.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_incident_screen.dart';
import 'screens/emergency_contacts_screen.dart';

class SmartCivicWatchApp extends StatelessWidget {
  const SmartCivicWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Civic Watch',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/report': (context) => const ReportIncidentScreen(),
        '/emergency': (context) => const EmergencyContactsScreen(),
      },
    );
  }
}
