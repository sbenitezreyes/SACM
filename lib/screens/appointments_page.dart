import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/appointment.dart';
import '../models/patient.dart';
import '../models/doctor.dart';
import '../constants.dart';

final apiService = ApiService(baseUrl: apiBaseUrl);

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Appointment> appointments = [];
  List<Appointment> filteredAppointments = [];
  Map<int, Patient> patientsMap = {};
  Map<int, Doctor> doctorsMap = {};
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    _searchController.addListener(_filterAppointments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAppointments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      // Cargar citas, pacientes y doctores en paralelo
      final results = await Future.wait([
        apiService.fetchAppointments(),
        apiService.fetchPatients(),
        apiService.get('/api/v1/doctors'),
      ]);
      
      final appointmentsData = results[0] as List<Appointment>;
      final patientsData = results[1] as List<Patient>;
      final doctorsData = results[2] as List;
      
      // Crear mapas para búsqueda rápida
      final patientsMapTemp = <int, Patient>{};
      for (var patient in patientsData) {
        final patientId = int.tryParse(patient.id);
        if (patientId != null) {
          patientsMapTemp[patientId] = patient;
        }
      }
      
      final doctorsMapTemp = <int, Doctor>{};
      for (var doctorJson in doctorsData) {
        final doctor = Doctor.fromJson(doctorJson);
        doctorsMapTemp[doctor.id] = doctor;
      }
      
      setState(() {
        appointments = appointmentsData;
        filteredAppointments = appointmentsData;
        patientsMap = patientsMapTemp;
        doctorsMap = doctorsMapTemp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterAppointments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredAppointments = appointments;
      } else {
        filteredAppointments = appointments.where((appointment) {
          final patient = patientsMap[appointment.patientId];
          final doctor = doctorsMap[appointment.doctorId];
          
          final patientName = patient?.fullName.toLowerCase() ?? '';
          final patientDoc = patient?.documentId.toLowerCase() ?? '';
          final doctorName = doctor?.fullName.toLowerCase() ?? '';
          final appointmentId = appointment.id.toString();
          
          return patientName.contains(query) || 
                 patientDoc.contains(query) || 
                 doctorName.contains(query) ||
                 appointmentId.contains(query);
        }).toList();
      }
    });
  }

  String getPatientName(int patientId) {
    return patientsMap[patientId]?.fullName ?? 'Paciente ID: $patientId';
  }

  String getPatientDocument(int patientId) {
    return patientsMap[patientId]?.documentId ?? '';
  }

  String getDoctorName(int doctorId) {
    return doctorsMap[doctorId]?.fullName ?? 'Doctor ID: $doctorId';
  }

  String getDoctorSpecialty(int doctorId) {
    return doctorsMap[doctorId]?.specialty ?? '';
  }

  Future<void> deleteAppointment(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Cita'),
        content: Text('¿Estás seguro de que deseas eliminar esta cita? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        print('Eliminando cita con ID: $id');
        await apiService.deleteAppointment(id);
        
        // Cerrar el diálogo de carga
        if (!mounted) return;
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Cita eliminada exitosamente'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Recargar la lista de citas
        await fetchAppointments();
      } catch (e) {
        print('Error al eliminar cita: $e');
        
        // Cerrar el diálogo de carga
        if (!mounted) return;
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Error al eliminar: ${e.toString().replaceAll('Exception: ', '')}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> confirmAppointment(int id) async {
    try {
      await apiService.confirmAppointment(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cita confirmada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      fetchAppointments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al confirmar la cita: $e')),
      );
    }
  }

  Future<void> completeAppointment(int id) async {
    try {
      await apiService.completeAppointment(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cita completada exitosamente'),
          backgroundColor: Colors.blue,
        ),
      );
      fetchAppointments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al completar la cita: $e')),
      );
    }
  }

  Future<void> cancelAppointment(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar Cita'),
        content: Text('¿Estás seguro de que deseas cancelar esta cita?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Sí, Cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await apiService.cancelAppointment(id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cita cancelada'),
            backgroundColor: Colors.orange,
          ),
        );
        fetchAppointments();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cancelar la cita: $e')),
        );
      }
    }
  }

  Future<void> rescheduleAppointment(int id) async {
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
        final newDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        try {
          await apiService.rescheduleAppointment(id, newDateTime.toIso8601String());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cita reprogramada exitosamente'),
              backgroundColor: Colors.purple,
            ),
          );
          fetchAppointments();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al reprogramar la cita: $e')),
          );
        }
      }
    }
  }

  void handleAppointmentAction(String action, Appointment appointment, BuildContext context) async {
    if (!context.mounted) return;

    switch (action) {
      case 'confirm':
        await confirmAppointment(appointment.id);
        break;
      case 'complete':
        await completeAppointment(appointment.id);
        break;
      case 'cancel':
        await cancelAppointment(appointment.id);
        break;
      case 'reschedule':
        await rescheduleAppointment(appointment.id);
        break;
      case 'delete':
        await deleteAppointment(appointment.id);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Acción desconocida')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Citas Médicas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await fetchAppointments();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lista actualizada'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : errorMessage != null
              ? _buildErrorState()
              : appointments.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        // Barra de búsqueda
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar por documento, nombre o ID de cita...',
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ),
                        // Contador de resultados
                        if (_searchController.text.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${filteredAppointments.length} resultado(s) encontrado(s)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        // Lista de citas
                        Expanded(
                          child: filteredAppointments.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                      SizedBox(height: 16),
                                      Text(
                                        'No se encontraron citas',
                                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Intenta con otro documento o nombre',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  itemCount: filteredAppointments.length,
                                  itemBuilder: (context, index) {
                                    final appointment = filteredAppointments[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.purple.withOpacity(0.03)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.12),
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
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).primaryColor,
                                              Theme.of(context).primaryColor.withOpacity(0.7),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(width: 16),
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
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          handleAppointmentAction(value, appointment, context);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        icon: Icon(Icons.more_vert),
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                          if (appointment.status == 'REQUESTED') ...[
                                            PopupMenuItem<String>(
                                              value: 'confirm',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.check_circle, size: 20, color: Colors.green),
                                                  SizedBox(width: 12),
                                                  Text('Confirmar'),
                                                ],
                                              ),
                                            ),
                                          ],
                                          if (appointment.status == 'CONFIRMED') ...[
                                            PopupMenuItem<String>(
                                              value: 'complete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.check, size: 20, color: Colors.blue),
                                                  SizedBox(width: 12),
                                                  Text('Completar'),
                                                ],
                                              ),
                                            ),
                                          ],
                                          if (appointment.status != 'COMPLETED' && appointment.status != 'CANCELLED') ...[
                                            PopupMenuItem<String>(
                                              value: 'reschedule',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.schedule, size: 20, color: Colors.purple),
                                                  SizedBox(width: 12),
                                                  Text('Reprogramar'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'cancel',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.cancel, size: 20, color: Colors.orange),
                                                  SizedBox(width: 12),
                                                  Text('Cancelar'),
                                                ],
                                              ),
                                            ),
                                          ],
                                          PopupMenuDivider(),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, size: 20, color: Colors.red),
                                                SizedBox(width: 12),
                                                Text('Eliminar', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(height: 24),
                                  Row(
                                    children: [
                                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Paciente: ${getPatientName(appointment.patientId)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
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
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (getDoctorSpecialty(appointment.doctorId).isNotEmpty)
                                              Text(
                                                getDoctorSpecialty(appointment.doctorId),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[500],
                                                ),
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
                                      Expanded(
                                        child: Text(
                                          DateTime.parse(appointment.startAt).toLocal().toString().substring(0, 16),
                                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                        ),
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
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
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
                      ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/create_appointment');
          if (result == true) {
            fetchAppointments();
          }
        },
        icon: Icon(Icons.add),
        label: Text('Nueva Cita'),
        tooltip: 'Crear nueva cita',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No hay citas programadas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Presiona el botón + para crear una',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: fetchAppointments,
            icon: Icon(Icons.refresh),
            label: Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}