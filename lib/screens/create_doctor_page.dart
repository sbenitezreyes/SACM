import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../services/api_service.dart';
import 'doctor_details_page.dart';

class CreateDoctorPage extends StatefulWidget {
  @override
  State<CreateDoctorPage> createState() => _CreateDoctorPageState();
}

class _CreateDoctorPageState extends State<CreateDoctorPage> {
  bool isLoading = false;
  String? errorMessage;
  Doctor? doctorDetails;
  List<Appointment> appointments = [];

  final ApiService apiService = ApiService(baseUrl: apiBaseUrl);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  
  // Lista de especialidades médicas en orden alfabético
  static const List<String> medicalSpecialties = [
    'Alergólogo',
    'Algólogo',
    'Andrólogo',
    'Anestesiólogo',
    'Audiólogo',
    'Cardiólogo',
    'Cirujano Cardiovascular',
    'Cirujano de Tórax',
    'Cirujano General',
    'Cirujano Maxilofacial',
    'Cirujano Oncólogo',
    'Cirujano Pediátrico',
    'Cirujano Plástico y Reconstructivo',
    'Cirujano Vascular',
    'Dermatólogo',
    'Endocrinólogo',
    'Fisiatra',
    'Fisioterapeuta',
    'Gastroenterólogo',
    'Genetista',
    'Geriatra',
    'Ginecólogo',
    'Hematólogo',
    'Imagenólogo',
    'Infectólogo',
    'Intensivista',
    'Internista',
    'Médico de Salud Pública',
    'Médico de Urgencias',
    'Médico del Trabajo',
    'Médico Deportólogo',
    'Médico Familiar',
    'Médico General',
    'Médico Nuclear',
    'Médico Preventivista',
    'Nefrólogo',
    'Neonatólogo',
    'Neumólogo',
    'Neurocirujano',
    'Neurólogo',
    'Nutriólogo',
    'Obstetra',
    'Oftalmólogo',
    'Oncólogo',
    'Ortopedista',
    'Otorrinolaringólogo',
    'Patólogo Clínico',
    'Pediatra',
    'Proctólogo',
    'Psicólogo Clínico',
    'Psiquiatra',
    'Radiólogo',
    'Reumatólogo',
    'Toxicólogo',
    'Traumatólogo',
    'Urólogo',
  ];

  Future<void> simulateCreateDoctor(Map<String, dynamic> doctorData) async {
    // Simulación de creación de médico
    await Future.delayed(Duration(seconds: 1));
    print('Médico creado exitosamente (simulación)');
  }

  Future<void> fetchDoctorData(int doctorId, DateTime from, DateTime to) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Cargar datos del doctor y sus citas entre fechas
      final results = await Future.wait([
        apiService.get('/api/v1/doctors/$doctorId'),
        apiService.get('/api/v1/appointments/doctor/$doctorId?from=${from.toIso8601String()}&to=${to.toIso8601String()}'),
      ]);

      final doctorJson = results[0] as Map<String, dynamic>;
      final appointmentsData = results[1] as List;

      setState(() {
        doctorDetails = Doctor.fromJson(doctorJson);
        appointments = appointmentsData.map((json) => Appointment.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar datos: $e';
        isLoading = false;
      });
    }
  }

  void onThreeDotsPressed(int doctorId) {
    final from = DateTime.now().subtract(Duration(days: 30));
    final to = DateTime.now();
    fetchDoctorData(doctorId, from, to);
  }

  Widget buildDoctorListTile(Doctor doctor) {
    return ListTile(
      contentPadding: EdgeInsets.all(16),
      title: Text(doctor.fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      subtitle: Text('Especialidad: ${doctor.specialty}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/doctor_details',
          arguments: doctor.id,
        );
      },
    );
  }

  Widget buildDoctorCard(Doctor doctor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(doctor.fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text('Especialidad: ${doctor.specialty}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailsPage(doctorId: doctor.id),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? doctor = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (doctor != null) {
      _nameController.text = (doctor['fullName'] ?? '').toString();
      _specialtyController.text = (doctor['specialty'] ?? '').toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          doctor == null ? 'Nuevo Médico' : 'Actualizar Médico',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icono superior
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medical_services,
                      size: 48,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // Campo de nombre
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Campo de especialidad con autocompletado
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return medicalSpecialties;
                    }
                    return medicalSpecialties.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    _specialtyController.text = selection;
                  },
                  fieldViewBuilder: (BuildContext context, 
                      TextEditingController fieldTextEditingController, 
                      FocusNode fieldFocusNode, 
                      VoidCallback onFieldSubmitted) {
                    // Sincronizar el controller externo con el interno
                    if (_specialtyController.text.isNotEmpty && fieldTextEditingController.text.isEmpty) {
                      fieldTextEditingController.text = _specialtyController.text;
                    }
                    
                    fieldTextEditingController.addListener(() {
                      _specialtyController.text = fieldTextEditingController.text;
                    });
                    
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Especialidad',
                        hintText: 'Selecciona o escribe una especialidad',
                        prefixIcon: Icon(Icons.local_hospital),
                        suffixIcon: fieldTextEditingController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  fieldTextEditingController.clear();
                                  _specialtyController.clear();
                                },
                              )
                            : Icon(Icons.arrow_drop_down),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                  optionsViewBuilder: (BuildContext context, 
                      AutocompleteOnSelected<String> onSelected, 
                      Iterable<String> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300,
                            maxWidth: MediaQuery.of(context).size.width - 48,
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.medical_services,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32),
                
                // Botones
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
                          final fullName = _nameController.text;
                          final specialty = _specialtyController.text;

                          if (fullName.isEmpty || specialty.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text('Datos Inválidos'),
                                  ],
                                ),
                                content: Text('Por favor, complete todos los campos.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('ACEPTAR'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (doctor == null) {
                            try {
                              final response = await http.post(
                                Uri.parse(
                                  apiBaseUrl + '/api/v1/doctors'
                                ),
                                headers: {'Content-Type': 'application/json'},
                                body: json.encode({
                                  'fullName': fullName,
                                  'specialty': specialty,
                                }),
                              );
                              if (response.statusCode == 201 || response.statusCode == 200) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text('Médico creado exitosamente'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context, true);
                              } else {
                                throw Exception('Error al crear médico: ${response.body}');
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.error, color: Colors.white),
                                      SizedBox(width: 8),
                                      Expanded(child: Text('Error: $e')),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            try {
                              final response = await http.put(
                                Uri.parse(
                                  apiBaseUrl + '/api/v1/doctors/${doctor['id']}'
                                ),
                                headers: {'Content-Type': 'application/json'},
                                body: json.encode({
                                  'fullName': fullName,
                                  'specialty': specialty,
                                }),
                              );
                              if (response.statusCode == 200) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text('Médico actualizado exitosamente'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context, true);
                              } else {
                                throw Exception('Error al actualizar médico: ${response.body}');
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.error, color: Colors.white),
                                      SizedBox(width: 8),
                                      Expanded(child: Text('Error: $e')),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(doctor == null ? 'GUARDAR' : 'ACTUALIZAR'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
