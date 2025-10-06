import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/patients_page.dart';
import 'screens/create_patient_page.dart';
import 'screens/patient_details_page.dart';
import 'screens/appointments_page.dart';
import 'screens/doctors_page.dart';
import 'screens/create_doctor_page.dart';
import 'screens/create_appointment_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Sistema de Gestión Médica',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/patients': (context) => PatientsPage(),
          '/create_patient': (context) => CreatePatientPage(),
          '/patient_details': (context) => PatientDetailsPage(patientId: 0),
          '/appointments': (context) => AppointmentsPage(),
          '/doctors': (context) => DoctorsPage(),
          '/create_doctor': (context) => CreateDoctorPage(),
          '/create_appointment': (context) => CreateAppointmentPage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Mantener solo el estado necesario para la aplicación actual
}
