import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../services/api_service.dart';
import '../constants.dart';

class DoctorDetailsPage extends StatefulWidget {
  final int doctorId;

  const DoctorDetailsPage({Key? key, required this.doctorId}) : super(key: key);

  @override
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> with SingleTickerProviderStateMixin {
  Doctor? doctorDetails;
  List<Appointment> appointments = [];
  bool isLoading = true;
  String? errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Cargar datos del doctor y sus citas entre fechas
      final results = await Future.wait([
        ApiService(baseUrl: apiBaseUrl).get('/api/v1/doctors/${widget.doctorId}'),
        ApiService(baseUrl: apiBaseUrl).get('/api/v1/appointments/doctor/${widget.doctorId}?from=${DateTime.now().subtract(Duration(days:30)).toIso8601String()}&to=${DateTime.now().toIso8601String()}'),
      ]);

      final doctorJson = results[0] as Map<String, dynamic>;
      final appointmentsData = (results[1] as List).map((json) => Appointment.fromJson(json)).toList();

      setState(() {
        doctorDetails = Doctor.fromJson(doctorJson);
        appointments = appointmentsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar datos: $e';
        isLoading = false;
      });
    }
  }

  void _showEditDialog() {
    final _nameController = TextEditingController(text: doctorDetails!.fullName);
    String _selectedSpecialty = doctorDetails!.specialty;
    final List<String> specialties = [
      'Cardiología',
      'Dermatología',
      'Pediatría',
      'Neurología',
      'Oncología',
    ];

    // Asegurarse de que la especialidad actual esté en la lista
    if (!specialties.contains(_selectedSpecialty)) {
      specialties.add(_selectedSpecialty);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Médico'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                items: specialties.map((specialty) {
                  return DropdownMenuItem(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _selectedSpecialty = value;
                  }
                },
                decoration: InputDecoration(labelText: 'Especialidad'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para actualizar los datos del médico
                final updatedDoctor = doctorDetails!.copyWith(
                  fullName: _nameController.text,
                  specialty: _selectedSpecialty,
                );
                _updateDoctor(updatedDoctor);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _updateDoctor(Doctor updatedDoctor) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Llamar al servicio API para actualizar los datos del médico
      await ApiService(baseUrl: apiBaseUrl).put('/api/v1/doctors/${updatedDoctor.id}', updatedDoctor.toJson());

      // Actualizar el estado local
      setState(() {
        doctorDetails = updatedDoctor;
        isLoading = false;
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos del médico actualizados con éxito.')),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error al actualizar datos: $e';
        isLoading = false;
      });
    }
  }

  void deleteDoctor() {
    // Implementación básica para eliminar un médico
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidad de eliminación pendiente de implementar.')),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card de información personal
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          doctorDetails!.fullName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorDetails!.fullName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ID: ${doctorDetails!.id}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                        onPressed: () => _showEditDialog(),
                        tooltip: 'Editar información',
                      ),
                    ],
                  ),
                  Divider(height: 32),
                  _buildInfoRow(Icons.badge, 'Especialidad', doctorDetails!.specialty),
                  SizedBox(height: 12),
                  _buildInfoRow(Icons.calendar_month, 'Citas totales', '${appointments.length}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          // Botón eliminar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: deleteDoctor,
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text('Eliminar Médico', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsTab() {
    if (appointments.isEmpty) {
      return Center(
        child: Text(
          'Este doctor no tiene citas programadas.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text('Paciente ID: ${appointment.patientId}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha: ${appointment.startAt}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text('Estado: ${appointment.status}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              onPressed: () => _showEditAppointmentDialog(appointment),
              tooltip: 'Editar cita',
            ),
          ),
        );
      },
    );
  }

  void _showEditAppointmentDialog(Appointment appointment) {
    // Implementación básica para editar una cita
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Cita'),
          content: Text('Funcionalidad de edición pendiente de implementar para la cita con ID: ${appointment.id}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Médico'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.person), text: 'Información'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Citas'),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(errorMessage!, textAlign: TextAlign.center),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchDoctorData,
                        child: Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInfoTab(),
                    _buildAppointmentsTab(),
                  ],
                ),
    );
  }
}