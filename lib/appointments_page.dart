import 'package:flutter/material.dart';

class Appointment {
  final String doctorName;
  final String patientName;
  final String time;

  Appointment({required this.doctorName, required this.patientName, required this.time});
}

class AppointmentManagementScreen extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(doctorName: 'Dr. Smith', patientName: 'John Doe', time: '10:00 AM'),
    Appointment(doctorName: 'Dr. Jones', patientName: 'Jane Doe', time: '10:30 AM'),
    // Add more appointments here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Citas'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return ListTile(
            title: Text('Cita con ${appointment.doctorName}'),
            subtitle: Text('Paciente: ${appointment.patientName}\nHora: ${appointment.time}'),
          );
        },
      ),
    );
  }
}