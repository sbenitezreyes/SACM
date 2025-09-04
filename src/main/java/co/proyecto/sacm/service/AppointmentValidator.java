package co.proyecto.sacm.service;

import co.proyecto.sacm.model.Doctor;
import co.proyecto.sacm.exception.BusinessException;
import co.proyecto.sacm.repository.AppointmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
public class AppointmentValidator {

    private final AppointmentRepository appointmentRepository;

    public void validateTimes(LocalDateTime start, LocalDateTime end) {
        if (end.isBefore(start) || end.isEqual(start))
            throw new BusinessException("La hora de fin debe ser mayor a la de inicio");
    }

    public void ensureNoOverlap(Doctor doctor, LocalDateTime start, LocalDateTime end) {
        boolean overlap = appointmentRepository
                .existsByDoctorAndStartAtLessThanAndEndAtGreaterThan(doctor, end, start);
        if (overlap) throw new BusinessException("Conflicto: el médico ya tiene una cita en ese rango");
    }
}
