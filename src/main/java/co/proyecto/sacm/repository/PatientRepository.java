package co.proyecto.sacm.repository;

import co.proyecto.sacm.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatientRepository extends JpaRepository<Patient, Long> {}
