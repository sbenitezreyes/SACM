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
import 'screens/doctor_details_page.dart';

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
        onGenerateRoute: (settings) {
          // Manejo de rutas con argumentos
          if (settings.name == '/patient_details') {
            final patientId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => PatientDetailsPage(patientId: patientId),
            );
          } else if (settings.name == '/doctor_details') {
            final doctorId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => DoctorDetailsPage(doctorId: doctorId),
            );
          }
          
          // Rutas sin argumentos
          Widget page;
          switch (settings.name) {
            case '/login':
              page = LoginPage();
              break;
            case '/home':
              page = HomePage();
              break;
            case '/patients':
              page = PatientsPage();
              break;
            case '/create_patient':
              page = CreatePatientPage();
              break;
            case '/appointments':
              page = AppointmentsPage();
              break;
            case '/doctors':
              page = DoctorsPage();
              break;
            case '/create_doctor':
              page = CreateDoctorPage();
              break;
            case '/create_appointment':
              page = CreateAppointmentPage();
              break;
            default:
              page = LoginPage();
          }
          
          return MaterialPageRoute(builder: (context) => page);
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Mantener solo el estado necesario para la aplicación actual
}
