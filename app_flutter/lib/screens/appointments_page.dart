import 'package:flutter/material.dart';
import '../services/api_service.dart';

final apiService = ApiService(baseUrl: 'http://3.142.93.102:8085');

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<dynamic> appointments = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      // El endpoint /api/v1/appointments no permite GET (405)
      // Debes consultar la documentación de la API para saber qué endpoint usar para obtener citas
      // Por ejemplo, si existe /api/v1/appointments/patient/{id} o /api/v1/appointments/doctor/{id}
      // Aquí dejo un ejemplo genérico:
      final data = await apiService.get('/api/v1/appointments/patient/1'); // Ajusta el endpoint según tu API
      setState(() {
        appointments = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await apiService.delete('/api/v1/appointments/$id');
      setState(() {
        appointments.removeWhere((appointment) => appointment['id'].toString() == id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la cita: $e')),
      );
    }
  }

  void handleAppointmentAction(String action, Map<String, dynamic> appointment, BuildContext context) async {
    if (!context.mounted) return; // Verificar si el widget sigue montado

    switch (action) {
      case 'confirm':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cita confirmada: ${appointment['date']}')),
        );
        break;
      case 'cancel':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cita cancelada: ${appointment['date']}')),
        );
        break;
      case 'reschedule':
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
            final combinedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            // Eliminar referencias a métodos de ejemplo

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cita reprogramada para: ${combinedDateTime.toLocal()}')),
            );
          }
        }
        break;
      case 'create':
        Navigator.pushNamed(context, '/create_appointment');
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
        title: Text('Gestión de Citas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return ListTile(
                      title: Text('Cita con ${appointment['doctor']} (${appointment['specialty']})'),
                      subtitle: Text('Paciente: ${appointment['patient']}\nFecha: ${appointment['date']}\nHora: ${appointment['time']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          handleAppointmentAction(value, appointment, context);
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'confirm',
                            child: Text('Confirmar'),
                          ),
                          PopupMenuItem<String>(
                            value: 'cancel',
                            child: Text('Cancelar'),
                          ),
                          PopupMenuItem<String>(
                            value: 'reschedule',
                            child: Text('Reprogramar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleAppointmentAction('create', {}, context);
        },
        child: Icon(Icons.add),
        tooltip: 'Crear nueva cita',
      ),
    );
  }
}