package co.proyecto.sacm.controller;
import co.proyecto.sacm.dto.DoctorRequestDTO;
import co.proyecto.sacm.model.Doctor;
import co.proyecto.sacm.service.DoctorService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/doctors")
@RequiredArgsConstructor // inyecta el service por constructor (Lombok)
public class DoctorController {

    // Inyectar el service
    private final DoctorService service;

    /**
     * Crear médico A PARTIR DE LOS DATOS DEL DTO de entrada
     *  Devuelve 201 Created con la URL del nuevo recurso en Location
     */
    @Operation(summary = "Crear médico")
    @PostMapping
    public ResponseEntity<Doctor> create(@Valid @RequestBody DoctorRequestDTO req){
        var saved = service.create(Doctor.builder() 
                .fullName(req.getFullName())
                .specialty(req.getSpecialty()).build());
        return ResponseEntity.created(URI.create("/api/v1/doctors/"+saved.getId())).body(saved);
    }

    /**
     * Listar médicos
     */
    @Operation(summary = "Listar médicos")
    @GetMapping public List<Doctor> list(){ return service.list(); }

    /**
     * Obtener médico por id
     */
    @Operation(summary = "Obtener médico por id")
    @GetMapping("/{id}") public Doctor get(@PathVariable Long id){ return service.get(id); }

    /**
     * Actualizar médico
     */
    @Operation(summary = "Actualizar médico")
    @PutMapping("/{id}")
    public Doctor update(@PathVariable Long id, @Valid @RequestBody DoctorRequestDTO req){
        return service.update(id, Doctor.builder() //delegar a service
                .fullName(req.getFullName()).specialty(req.getSpecialty()).build());
    }

    /**
     * Eliminar médico
     *  Devuelve 204 No Content al no retornar cuerpo
     */
    @Operation(summary = "Eliminar médico")
    @DeleteMapping("/{id}") public ResponseEntity<Void> delete(@PathVariable Long id){
        service.delete(id); return ResponseEntity.noContent().build();
    }
}
