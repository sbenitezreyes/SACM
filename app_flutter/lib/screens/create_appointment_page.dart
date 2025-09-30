import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAppointmentPage extends StatefulWidget {
  @override
  _CreateAppointmentPageState createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final TextEditingController _documentSearchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int? selectedPatientId;
  String? selectedPatientName;
  int? selectedDoctorId;
  String? selectedDoctorName;
  String? selectedSpecialty;
  DateTime? selectedStartAt;
  DateTime? selectedEndAt;

  List<dynamic> patients = [];
  List<dynamic> filteredPatients = [];
  List<dynamic> doctors = [];
  List<String> specialties = [];
  List<dynamic> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
    fetchDoctors();
  }

  Future<void> fetchPatients() async {
  final response = await http.get(Uri.parse('http://3.142.93.102:8085/api/v1/patients'));
    if (response.statusCode == 200) {
      setState(() {
        patients = json.decode(response.body);
        filteredPatients = [];
      });
    }
  }

  Future<void> fetchDoctors() async {
  final response = await http.get(Uri.parse('http://3.142.93.102:8085/api/v1/doctors'));
    if (response.statusCode == 200) {
      setState(() {
        doctors = json.decode(response.body);
        specialties = doctors.map<String>((d) => d['specialty'].toString()).toSet().toList();
        filteredDoctors = doctors;
      });
    }
  }

  void filterPatients(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPatients = [];
      } else {
        filteredPatients = patients.where((p) => p['documentId'].toString().contains(query)).toList();
      }
    });
  }

  void filterDoctorsBySpecialty(String specialty) {
    setState(() {
      filteredDoctors = doctors.where((d) => d['specialty'] == specialty).toList();
    });
  }

  Future<void> createAppointment() async {
    if (selectedPatientId == null || selectedDoctorId == null || selectedStartAt == null || selectedEndAt == null || _notesController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completa todos los campos antes de crear la cita.')),
      );
      return;
    }
    final appointmentData = {
      'doctorId': selectedDoctorId,
      'patientId': selectedPatientId,
  'startAt': selectedStartAt!.toIso8601String(),
  'endAt': selectedEndAt!.toIso8601String(),
      'notes': _notesController.text,
    };
  print('JSON enviado a la API: ${json.encode(appointmentData)}');
    // Validar tipos y valores
    if (appointmentData.values.any((v) => v == null || (v is String && v.isEmpty))) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verifica que todos los campos tengan valores válidos.')),
      );
      return;
    }
    final response = await http.post(
  Uri.parse('http://3.142.93.102:8085/api/v1/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(appointmentData),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita creada exitosamente.')),
      );
      Navigator.pop(context, true);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear cita: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Nueva Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buscar paciente por documento'),
              TextField(
                controller: _documentSearchController,
                decoration: InputDecoration(labelText: 'Documento'),
                onChanged: filterPatients,
              ),
              SizedBox(height: 8),
              ...filteredPatients.map((p) => ListTile(
                title: Text(p['fullName'] ?? ''),
                subtitle: Text('Documento: ${p['documentId']}'),
                onTap: () {
                  setState(() {
                    selectedPatientId = int.tryParse(p['id'].toString());
                    selectedPatientName = p['fullName'];
                  });
                },
                selected: selectedPatientId == int.tryParse(p['id'].toString()),
              )),
              SizedBox(height: 16),
              if (selectedPatientName != null)
                Text('Paciente seleccionado: $selectedPatientName'),
              Divider(),
              Text('Seleccionar especialidad de médico'),
              DropdownButton<String>(
                value: selectedSpecialty,
                hint: Text('Especialidad'),
                items: specialties.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSpecialty = value;
                    filterDoctorsBySpecialty(value!);
                    selectedDoctorId = null;
                    selectedDoctorName = null;
                  });
                },
              ),
              SizedBox(height: 8),
              ...filteredDoctors.map((d) => ListTile(
                title: Text(d['fullName'] ?? ''),
                subtitle: Text('Especialidad: ${d['specialty']}'),
                onTap: () {
                  setState(() {
                    selectedDoctorId = int.tryParse(d['id'].toString());
                    selectedDoctorName = d['fullName'];
                  });
                },
                selected: selectedDoctorId == int.tryParse(d['id'].toString()),
              )),
              SizedBox(height: 16),
              if (selectedDoctorName != null)
                Text('Médico seleccionado: $selectedDoctorName'),
              Divider(),
              Text('Seleccionar fecha y hora de inicio'),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        selectedStartAt = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text(selectedStartAt == null ? 'Seleccionar fecha y hora de inicio' :
                  selectedStartAt == null ? 'Seleccionar fecha y hora de inicio' : selectedStartAt!.toLocal().toString()),
              ),
              SizedBox(height: 16),
              Text('Seleccionar fecha y hora de fin'),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedStartAt ?? DateTime.now(),
                    firstDate: selectedStartAt ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        selectedEndAt = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text(selectedEndAt == null ? 'Seleccionar fecha y hora de fin' :
                  selectedEndAt == null ? 'Seleccionar fecha y hora de fin' : selectedEndAt!.toLocal().toString()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notas'),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await createAppointment();
                },
                child: Text('Crear Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}