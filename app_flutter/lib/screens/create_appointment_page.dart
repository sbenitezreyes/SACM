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
    if (selectedPatientId == null || selectedDoctorId == null || selectedStartAt == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona paciente, doctor y fecha/hora antes de crear la cita.')),
      );
      return;
    }
    final appointmentData = {
      'doctorId': selectedDoctorId,
      'patientId': selectedPatientId,
      'startAt': selectedStartAt!.toIso8601String(),
      'notes': _notesController.text,
    };
    
    print('JSON enviado a la API: ${json.encode(appointmentData)}');
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
      appBar: AppBar(
        title: Text(
          'Nueva Cita Médica',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección Paciente
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.withOpacity(0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Seleccionar Paciente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _documentSearchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por documento',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: filterPatients,
                    ),
                    if (filteredPatients.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Container(
                        constraints: BoxConstraints(maxHeight: 150),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredPatients.length,
                          itemBuilder: (context, index) {
                            final p = filteredPatients[index];
                            final isSelected = selectedPatientId == int.tryParse(p['id'].toString());
                            return ListTile(
                              title: Text(p['fullName'] ?? ''),
                              subtitle: Text('Doc: ${p['documentId']}'),
                              selected: isSelected,
                              selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedPatientId = int.tryParse(p['id'].toString());
                                  selectedPatientName = p['fullName'];
                                  filteredPatients = [];
                                  _documentSearchController.clear();
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                    if (selectedPatientName != null) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Paciente: $selectedPatientName',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Sección Médico
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.green.withOpacity(0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medical_services, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Seleccionar Médico',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedSpecialty,
                      decoration: InputDecoration(
                        labelText: 'Especialidad',
                        prefixIcon: Icon(Icons.local_hospital),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
                    if (selectedSpecialty != null && filteredDoctors.isNotEmpty) ...[
                      SizedBox(height: 12),
                      ...filteredDoctors.map((d) {
                        final isSelected = selectedDoctorId == int.tryParse(d['id'].toString());
                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                          child: ListTile(
                            title: Text(d['fullName'] ?? ''),
                            subtitle: Text(d['specialty'] ?? ''),
                            leading: CircleAvatar(
                              backgroundColor: isSelected 
                                  ? Theme.of(context).primaryColor 
                                  : Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                color: isSelected ? Colors.white : Colors.grey[600],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedDoctorId = int.tryParse(d['id'].toString());
                                selectedDoctorName = d['fullName'];
                              });
                            },
                          ),
                        );
                      }),
                    ],
                    if (selectedDoctorName != null) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Médico: $selectedDoctorName',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Sección Fecha y Hora
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.purple.withOpacity(0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Fecha y Hora',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    OutlinedButton.icon(
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
                      icon: Icon(Icons.event),
                      label: Text(
                        selectedStartAt == null 
                            ? 'Fecha y hora de inicio' 
                            : selectedStartAt!.toLocal().toString().substring(0, 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Sección Notas
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.orange.withOpacity(0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notes, color: Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Notas Adicionales',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notas o comentarios (opcional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Escriba cualquier información adicional...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('CANCELAR'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      await createAppointment();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('CREAR CITA'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}