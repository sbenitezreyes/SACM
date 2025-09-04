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

@RestController
@RequestMapping("/api/v1/patients")
@RequiredArgsConstructor
public class PatientController {
    private final PatientService service;

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

    @Operation(summary = "Listar pacientes")
    @GetMapping public List<Patient> list() { return service.list(); }

    @Operation(summary = "Obtener paciente por id")
    @GetMapping("/{id}") public Patient get(@PathVariable Long id) { return service.get(id); }

    @Operation(summary = "Actualizar paciente")
    @PutMapping("/{id}")
    public Patient update(@PathVariable Long id, @RequestBody PatientRequestDTO req) {
        return service.update(id,
            Patient.builder()
                .fullName(req.getFullName())
                .email(req.getEmail())
                .build()
        );
    }

    @Operation(summary = "Eliminar paciente")
    @DeleteMapping("/{id}") public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id); return ResponseEntity.noContent().build();
    }
}
