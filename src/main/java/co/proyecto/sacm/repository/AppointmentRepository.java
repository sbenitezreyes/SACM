package co.proyecto.sacm.repository;

import co.proyecto.sacm.model.Appointment;
import co.proyecto.sacm.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {


    boolean existsByDoctorIdAndStartAtEquals(Long doctorId, LocalDateTime startAt);

    List<Appointment> findByDoctorIdAndStartAtBetween(Long doctorId, LocalDateTime from, LocalDateTime to);

    List<Appointment> findByPatientIdOrderByStartAtDesc(Long patientId);

    boolean existsByPatientAndStartAtBetween(Patient patient, LocalDateTime from, LocalDateTime to);
}
