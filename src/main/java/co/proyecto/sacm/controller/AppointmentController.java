package co.proyecto.sacm.controller;

import co.proyecto.sacm.dto.AppointmentRequestDTO;
import co.proyecto.sacm.dto.AppointmentResponseDTO;
import co.proyecto.sacm.service.AppointmentService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.springframework.format.annotation.DateTimeFormat.ISO;

@RestController
@RequestMapping("/api/v1/appointments")
@RequiredArgsConstructor
public class AppointmentController {

    private final AppointmentService appointmentService;

    @Operation(summary = "Crear cita")
    @PostMapping
    public ResponseEntity<AppointmentResponseDTO> create(@Valid @RequestBody AppointmentRequestDTO req) {
        return ResponseEntity.ok(appointmentService.create(req));
    }

    @Operation(summary = "Cancelar cita")
    @PostMapping("/{id}/cancel")
    public ResponseEntity<Void> cancel(@PathVariable Long id) {
        appointmentService.cancel(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Obtener cita por id")
    @GetMapping("/{id}")
    public ResponseEntity<AppointmentResponseDTO> get(@PathVariable Long id){
        return ResponseEntity.ok(appointmentService.get(id));
    }

    @Operation(summary = "Reprogramar cita")
    @PostMapping("/{id}/reschedule")
    public ResponseEntity<AppointmentResponseDTO> reschedule(@PathVariable Long id,
                                                             @Valid @RequestBody co.proyecto.sacm.dto.RescheduleRequestDTO req){
        return ResponseEntity.ok(
                appointmentService.reschedule(id, req.getStartAt(), req.getEndAt()));
    }

    @Operation(summary = "Confirmar cita")
    @PostMapping("/{id}/confirm")
    public ResponseEntity<AppointmentResponseDTO> confirm(@PathVariable Long id){
        return ResponseEntity.ok(appointmentService.confirm(id));
    }

    @Operation(summary = "Completar cita")
    @PostMapping("/{id}/complete")
    public ResponseEntity<AppointmentResponseDTO> complete(@PathVariable Long id){
        return ResponseEntity.ok(appointmentService.complete(id));
    }

    @Operation(summary = "Eliminar cita")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id){
        appointmentService.delete(id);
        return ResponseEntity.noContent().build();
    }
    // controller/AppointmentController.java  (añadir debajo de lo que ya tienes)


    @Operation(summary = "Listar citas de un doctor entre fechas")
    @GetMapping("/doctor/{doctorId}")
    public ResponseEntity<List<AppointmentResponseDTO>> listByDoctor(
            @PathVariable Long doctorId,
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE_TIME) LocalDateTime to
    ) {
        // Si no envían rangos, por defecto “hoy”
        if (from == null || to == null) {
            LocalDate today = LocalDate.now();
            from = today.atStartOfDay();
            to   = today.atTime(23, 59, 59);
        }
        return ResponseEntity.ok(appointmentService.listByDoctorAndDay(doctorId, from, to));
    }

    @Operation(summary = "Listar citas de un paciente (historial)")
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<AppointmentResponseDTO>> listByPatient(@PathVariable Long patientId) {
        return ResponseEntity.ok(appointmentService.listByPatient(patientId));
    }


}
