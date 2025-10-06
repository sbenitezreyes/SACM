import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../models/patient.dart';

class HomePage extends StatelessWidget {
  final ApiService apiService = ApiService(baseUrl: 'http://3.142.93.102:8085');

  // Método para verificar la conexión a Internet antes de realizar la solicitud
  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> checkApiConnection() async {
    try {
      if (!await isConnectedToInternet()) {
        throw Exception('No hay conexión a Internet');
      }

      final response = await apiService.get('/actuator/health');
      print('Respuesta de la API: $response'); // Imprime la respuesta completa
      if (response != null && response['status'] == 'UP') {
        return true;
      } else {
        throw Exception('La API respondió pero no está en estado UP');
      }
    } catch (e) {
      print('Error al conectar con la API: $e'); // Imprime el error
      throw Exception('Error al conectar con la API: $e');
    }
  }

  // Método para realizar un ping a la API con timeout
  Future<bool> pingApiWithTimeout() async {
    try {
      final response = await apiService.get('/actuator/health').timeout(Duration(seconds: 5));
      return response['status'] == 'UP';
    } catch (e) {
      print('Error o timeout al hacer ping a la API: $e');
      return false;
    }
  }

  Future<List<Patient>> fetchPatients() async {
    try {
      if (!await isConnectedToInternet()) {
        throw Exception('No hay conexión a Internet');
      }

      final patients = await apiService.fetchPatients();
      return patients;
    } catch (e) {
      print('Error al obtener pacientes: $e');
      throw Exception('Error al obtener pacientes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: fetchPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text(patient.fullName),
                  subtitle: Text(patient.email),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/patients');
            },
            tooltip: 'Pacientes',
            child: Icon(Icons.people),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/appointments');
            },
            tooltip: 'Citas',
            child: Icon(Icons.calendar_today),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/doctors');
            },
            tooltip: 'Médicos',
            child: Icon(Icons.medical_services),
          ),
        ],
      ),
    );
  }
}