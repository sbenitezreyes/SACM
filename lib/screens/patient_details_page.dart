import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../models/appointment.dart';
import '../models/patient.dart';
import '../models/doctor.dart';
import '../constants.dart';

final apiService = ApiService(baseUrl: apiBaseUrl);

class PatientDetailsPage extends StatefulWidget {
  final int patientId;

  const PatientDetailsPage({Key? key, required this.patientId}) : super(key: key);

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> with SingleTickerProviderStateMixin {
  Patient? patientDetails;
  List<Appointment> appointments = [];
  Map<int, Doctor> doctorsMap = {};
  bool isLoading = true;
  String? errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchPatientData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchPatientData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Cargar datos del paciente, sus citas y doctores en paralelo
      final results = await Future.wait([
        apiService.get('/api/v1/patients/${widget.patientId}'),
        apiService.fetchAppointmentsByPatient(widget.patientId),
        apiService.get('/api/v1/doctors'),
      ]);

      final patientJson = results[0] as Map<String, dynamic>;
      final appointmentsData = results[1] as List<Appointment>;
      final doctorsData = results[2] as List;

      // Crear mapa de doctores
      final doctorsMapTemp = <int, Doctor>{};
      for (var doctorJson in doctorsData) {
        final doctor = Doctor.fromJson(doctorJson);
        doctorsMapTemp[doctor.id] = doctor;
      }

      setState(() {
        patientDetails = Patient.fromJson(patientJson);
        appointments = appointmentsData;
        doctorsMap = doctorsMapTemp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar datos: $e';
        isLoading = false;
      });
    }
  }

  String getDoctorName(int doctorId) {
    return doctorsMap[doctorId]?.fullName ?? 'Doctor ID: $doctorId';
  }

  String getDoctorSpecialty(int doctorId) {
    return doctorsMap[doctorId]?.specialty ?? '';
  }

  Future<void> deletePatient() async {
    try {
      final response = await http.delete(Uri.parse(apiBaseUrl + '/api/v1/patients/${widget.patientId}'));
      // Cambié la URL a HTTP pero mantuve HTTPS como opción para producción.
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paciente eliminado con éxito')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Paciente'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchPatientData,
            tooltip: 'Actualizar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.person), text: 'Información'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Historial de Citas'),
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
                        onPressed: fetchPatientData,
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
                          patientDetails!.fullName.substring(0, 1).toUpperCase(),
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
                              patientDetails!.fullName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ID: ${patientDetails!.id}',
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
                  _buildInfoRow(Icons.badge, 'Documento', patientDetails!.documentId),
                  SizedBox(height: 12),
                  _buildInfoRow(Icons.email, 'Correo', patientDetails!.email),
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
              onPressed: deletePatient,
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text('Eliminar Paciente', style: TextStyle(color: Colors.red)),
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
                  fontWeight: FontWeight.w500,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No hay citas registradas',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Este paciente aún no tiene historial de citas',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(int.parse(appointment.getStatusColor().substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: Color(int.parse(appointment.getStatusColor().substring(1), radix: 16) + 0xFF000000),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cita #${appointment.id}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(int.parse(appointment.getStatusColor().substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              appointment.getStatusText(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(int.parse(appointment.getStatusColor().substring(1), radix: 16) + 0xFF000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 24),
                Row(
                  children: [
                    Icon(Icons.medical_services, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${getDoctorName(appointment.doctorId)}',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          if (getDoctorSpecialty(appointment.doctorId).isNotEmpty)
                            Text(
                              getDoctorSpecialty(appointment.doctorId),
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text(
                      DateTime.parse(appointment.startAt).toLocal().toString().substring(0, 16),
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          appointment.notes!,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog() {
    final documentController = TextEditingController(text: patientDetails!.documentId);
    final nameController = TextEditingController(text: patientDetails!.fullName);
    final emailController = TextEditingController(text: patientDetails!.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.edit, color: Theme.of(context).primaryColor),
            SizedBox(width: 12),
            Text('Editar Paciente'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: documentController,
                decoration: InputDecoration(
                  labelText: 'Documento de Identidad',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validación básica
              if (documentController.text.isEmpty || 
                  nameController.text.isEmpty || 
                  emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Todos los campos son obligatorios')),
                );
                return;
              }

              try {
                // Actualizar paciente
                await apiService.put(
                  '/api/v1/patients/${widget.patientId}',
                  {
                    'documentId': documentController.text,
                    'fullName': nameController.text,
                    'email': emailController.text,
                  },
                );

                Navigator.pop(context);
                
                // Recargar datos
                await fetchPatientData();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Paciente actualizado exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al actualizar: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }
}