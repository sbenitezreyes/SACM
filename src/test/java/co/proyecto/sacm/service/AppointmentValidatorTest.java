package co.proyecto.sacm.service;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import org.mockito.Mockito;
import co.proyecto.sacm.repository.AppointmentRepository;
import co.proyecto.sacm.exception.BusinessException;
import co.proyecto.sacm.model.Doctor;
import java.time.LocalDateTime;

class AppointmentValidatorTest {

    @Test
    void testValidAppointment() {
        AppointmentRepository mockRepository = Mockito.mock(AppointmentRepository.class);
        AppointmentValidator validator = new AppointmentValidator(mockRepository);
        boolean result = validator.validateAppointment("Doctor", "Patient", "2025-10-10T10:00:00");
        assertTrue(result, "La cita válida debería pasar la validación");
    }

    @Test
    void testInvalidAppointment() {
        AppointmentRepository mockRepository = Mockito.mock(AppointmentRepository.class);
        AppointmentValidator validator = new AppointmentValidator(mockRepository);
        boolean result = validator.validateAppointment("", "Patient", "2025-10-10T10:00:00");
        assertFalse(result, "La cita inválida no debería pasar la validación");
    }

    @Test
    void testNullValues() {
        AppointmentRepository mockRepository = Mockito.mock(AppointmentRepository.class);
        AppointmentValidator validator = new AppointmentValidator(mockRepository);
        boolean result = validator.validateAppointment(null, null, null);
        assertFalse(result, "Los valores nulos no deberían pasar la validación");
    }

    @Test
    void testValidateTimes() {
        AppointmentRepository mockRepository = Mockito.mock(AppointmentRepository.class);
        AppointmentValidator validator = new AppointmentValidator(mockRepository);

        LocalDateTime start = LocalDateTime.of(2025, 10, 10, 10, 0);
        LocalDateTime endValid = LocalDateTime.of(2025, 10, 10, 11, 0);
        LocalDateTime endInvalid = LocalDateTime.of(2025, 10, 10, 9, 0);

        // Caso válido
        assertDoesNotThrow(() -> validator.validateTimes(start, endValid), "Las horas válidas no deberían lanzar excepción");

        // Caso inválido
        Exception exception = assertThrows(BusinessException.class, () -> validator.validateTimes(start, endInvalid));
        assertEquals("La hora de fin debe ser mayor a la de inicio", exception.getMessage());
    }

    @Test
    void testEnsureNoOverlap() {
        AppointmentRepository mockRepository = Mockito.mock(AppointmentRepository.class);
        AppointmentValidator validator = new AppointmentValidator(mockRepository);

        Doctor doctor = new Doctor();
        doctor.setId(1L);
        LocalDateTime start = LocalDateTime.of(2025, 10, 10, 10, 0);
        LocalDateTime end = LocalDateTime.of(2025, 10, 10, 11, 0);

        // Simular que no hay conflicto
        Mockito.when(mockRepository.existsByDoctorIdAndStartAtEquals(doctor.getId(), start)).thenReturn(false);
        assertDoesNotThrow(() -> validator.ensureNoOverlap(doctor, start, end), "No debería lanzar excepción si no hay conflicto");

        // Simular que hay conflicto
        Mockito.when(mockRepository.existsByDoctorIdAndStartAtEquals(doctor.getId(), start)).thenReturn(true);
        Exception exception = assertThrows(BusinessException.class, () -> validator.ensureNoOverlap(doctor, start, end));
        assertEquals("Conflicto: el médico ya tiene una cita en ese rango", exception.getMessage());
    }
}