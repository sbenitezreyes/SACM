package co.proyecto.sacm.controller;

import co.proyecto.sacm.dto.PatientRequestDTO;
import co.proyecto.sacm.model.Patient;
import co.proyecto.sacm.service.PatientService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

/** controlador REST para gestionar pacientes  CRUD */
@RestController  
@RequestMapping("/api/v1/patients")
@RequiredArgsConstructor
public class PatientController {

    // Inyectar el service
    private final PatientService service;

    /**
     * Crear paciente
     */
    @Operation(summary = "Crear paciente")
    @PostMapping
    public ResponseEntity<Patient> create(@RequestBody PatientRequestDTO req) {
        var saved = service.create(
            Patient.builder()
                .fullName(req.getFullName())
                .documentId(req.getDocumentId())
                .email(req.getEmail())
                .build()
        );
        return ResponseEntity.created(URI.create("/api/v1/patients/" + saved.getId())).body(saved);
    }

    /**
     * Listar pacientes
     */
    @Operation(summary = "Listar pacientes")
    @GetMapping public List<Patient> list() { return service.list(); }

    /**
     * Obtener paciente por id
     */
    @Operation(summary = "Obtener paciente por id")
    @GetMapping("/{id}") public Patient get(@PathVariable Long id) { return service.get(id); }

    /**
     * Actualizar paciente
     */
    @Operation(summary = "Actualizar paciente")
    @PutMapping("/{id}")
    public Patient update(@PathVariable Long id, @RequestBody PatientRequestDTO req) {
        return service.update(id, //delegar a service
            Patient.builder()
                .fullName(req.getFullName())
                .email(req.getEmail())
                .build()
        );
    }

    /**
     * Eliminar paciente
     *  Devuelve 204 No Content al no retornar cuerpo
     */
    @Operation(summary = "Eliminar paciente")
    @DeleteMapping("/{id}") public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id); return ResponseEntity.noContent().build();
    }
}
