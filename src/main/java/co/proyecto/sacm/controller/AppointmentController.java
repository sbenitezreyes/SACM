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
import org.springframework.format.annotation.DateTimeFormat.ISO;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.springframework.format.annotation.DateTimeFormat.ISO;

/**
 * Controlador HTTP para exponer endpoints REST de gestión de citas.
 * - Devuelve DTOs.
 */
@RestController
@RequestMapping("/api/v1/appointments")
@RequiredArgsConstructor // inyecta el service por constructor (Lombok)
public class AppointmentController {

    // Inyectar el service
    private final AppointmentService appointmentService;

    /**
     * Crear cita
     */
    @Operation(summary = "Crear cita")
    @PostMapping
    public ResponseEntity<AppointmentResponseDTO> create(@Valid @RequestBody AppointmentRequestDTO req) {
       // @Valid forzará a que el DTO cumpla sus anotaciones.
        // Si falla, un @ControllerAdvice puede mapearlo a 400.
        return ResponseEntity.ok(appointmentService.create(req));
        return ResponseEntity.ok(appointmentService.create(req)); 
    }

    /**
     * Cancelar cita
     */
    @Operation(summary = "Cancelar cita")
    @PostMapping("/{id}/cancel")
    public ResponseEntity<Void> cancel(@PathVariable Long id) {
        appointmentService.cancel(id);
        return ResponseEntity.noContent().build(); // 204 No Content
    }

    /**
     * Obtener cita por id
     */
    @Operation(summary = "Obtener cita por id")
    @GetMapping("/{id}")
    public ResponseEntity<AppointmentResponseDTO> get(@PathVariable Long id){
        return ResponseEntity.ok(appointmentService.get(id)); 
    }

    /**
     * Reprogramar cita
     */
    @Operation(summary = "Reprogramar cita")
    @PostMapping("/{id}/reschedule")
    public ResponseEntity<AppointmentResponseDTO> reschedule(@PathVariable Long id,
                                                             @Valid @RequestBody co.proyecto.sacm.dto.RescheduleRequestDTO req){
        return ResponseEntity.ok(
                appointmentService.reschedule(id, req.getStartAt(), req.getEndAt())); // delegar a service
    }

    /**
     *  marcar como cita confirmada
     */
    @Operation(summary = "Confirmar cita")
    @PostMapping("/{id}/confirm")
    public ResponseEntity<AppointmentResponseDTO> confirm(@PathVariable Long id){
        return ResponseEntity.ok(appointmentService.confirm(id));
    }

    /**
     *  marcar como cita completada
     */
    @Operation(summary = "Completar cita")
    @PostMapping("/{id}/complete")
    public ResponseEntity<AppointmentResponseDTO> complete(@PathVariable Long id){
        return ResponseEntity.ok(appointmentService.complete(id));
    }

    /**
     * Eliminar cita
     *  Devuelve 204 No Content al no retornar cuerpo
     */
    @Operation(summary = "Eliminar cita")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id){
        appointmentService.delete(id);
        return ResponseEntity.noContent().build();
    }
    // controller/AppointmentController.java  


    /**
     * Listar citas de un doctor entre fechas
     *  Si no envían fechas, por defecto “hoy”
     */
    @Operation(summary = "Listar citas de un doctor entre fechas")
    @GetMapping("/doctor/{doctorId}")
    public ResponseEntity<List<AppointmentResponseDTO>> listByDoctor(
            @PathVariable Long doctorId,
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE_TIME) LocalDateTime to
    ) {
        // Si no envían rangos, por defecto 
        if (from == null || to == null) {
            LocalDate today = LocalDate.now();
            from = today.atStartOfDay();
            to   = today.atTime(23, 59, 59);
        }
        return ResponseEntity.ok(appointmentService.listByDoctorAndDay(doctorId, from, to));
    }

    /**
     * Listar citas de un paciente (historial)
     */
    @Operation(summary = "Listar citas de un paciente (historial)")
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<AppointmentResponseDTO>> listByPatient(@PathVariable Long patientId) {
        return ResponseEntity.ok(appointmentService.listByPatient(patientId));
    }


}
