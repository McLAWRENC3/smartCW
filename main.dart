import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_incident_screen.dart';
import 'screens/emergency_contacts_screen.dart';
import 'screens/EmergencyAlertsScreen.dart';
import 'screens/map_screen.dart';
import 'screens/donations_screen.dart'; // ✅ Added donations screen import

void main() {
  runApp(const SmartCivicWatchApp());
}

class SmartCivicWatchApp extends StatelessWidget {
  const SmartCivicWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Civic Watch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/report': (context) => const ReportIncidentScreen(),
        '/contacts': (context) => const EmergencyContactsScreen(),
        '/alerts': (context) => const EmergencyAlertsScreen(),
        '/map': (context) => MapScreen(),
        '/donations': (context) => const DonationsScreen(), // ✅ Added donations page route
      },
    );
  }
}
