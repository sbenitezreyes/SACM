package co.proyecto.sacm.repository;

import co.proyecto.sacm.model.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorRepository extends JpaRepository<Doctor, Long> { }
