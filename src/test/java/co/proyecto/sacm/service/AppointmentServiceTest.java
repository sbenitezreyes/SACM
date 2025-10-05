package co.proyecto.sacm.service;

import co.proyecto.sacm.dto.AppointmentRequestDTO;
import co.proyecto.sacm.exception.BusinessException;
import co.proyecto.sacm.repository.AppointmentRepository;
import co.proyecto.sacm.repository.DoctorRepository;
import co.proyecto.sacm.repository.PatientRepository;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyLong;

public class AppointmentServiceTest {
    @Test
    void noDebeCrearCitaSiHorariosInvalidos() {
        // Mocks
        DoctorRepository doctorRepo = Mockito.mock(DoctorRepository.class);
        PatientRepository patientRepo = Mockito.mock(PatientRepository.class);
        AppointmentRepository appointmentRepo = Mockito.mock(AppointmentRepository.class);
        // Mock para el validador
        co.proyecto.sacm.service.AppointmentValidator validator = Mockito.mock(co.proyecto.sacm.service.AppointmentValidator.class);
        co.proyecto.sacm.integration.notifications.NotificationsClient notificationsClient = Mockito.mock(co.proyecto.sacm.integration.notifications.NotificationsClient.class);

        // Simula que médico y paciente existen
        Mockito.when(doctorRepo.findById(anyLong())).thenReturn(Optional.of(Mockito.mock(co.proyecto.sacm.model.Doctor.class)));
        Mockito.when(patientRepo.findById(anyLong())).thenReturn(Optional.of(Mockito.mock(co.proyecto.sacm.model.Patient.class)));

        // Simula que la validación de horarios lanza excepción
        Mockito.doThrow(new BusinessException("Horarios inválidos")).when(validator).validateTimes(Mockito.any(), Mockito.any());

        AppointmentService service = new AppointmentService(
                appointmentRepo, doctorRepo, patientRepo, validator, notificationsClient
        );

        AppointmentRequestDTO req = new AppointmentRequestDTO();
        req.setDoctorId(1L);
        req.setPatientId(1L);
        req.setStartAt(java.time.LocalDateTime.now().plusDays(1));

        // Verifica que se lanza la excepción por horarios inválidos
        assertThrows(BusinessException.class, () -> service.create(req));
    }

    @Test
    void noDebeCrearCitaSiMedicoNoExiste() {
        // Mocks
        DoctorRepository doctorRepo = Mockito.mock(DoctorRepository.class);
        PatientRepository patientRepo = Mockito.mock(PatientRepository.class);
        AppointmentRepository appointmentRepo = Mockito.mock(AppointmentRepository.class);
        co.proyecto.sacm.integration.notifications.NotificationsClient notificationsClient = Mockito.mock(co.proyecto.sacm.integration.notifications.NotificationsClient.class);

        // Simula que el médico no existe
        Mockito.when(doctorRepo.findById(anyLong())).thenReturn(Optional.empty());

        // Instancia el servicio con los mocks y dependencias mínimas
        AppointmentService service = new AppointmentService(
                appointmentRepo, doctorRepo, patientRepo, null, notificationsClient
        );

        AppointmentRequestDTO req = new AppointmentRequestDTO();
        req.setDoctorId(1L);
        req.setPatientId(1L);

        // Verifica que se lanza la excepción
        assertThrows(BusinessException.class, () -> service.create(req));
    }

    @Test
    void noDebeCrearCitaSiPacienteNoExiste() {
        // Mocks
        DoctorRepository doctorRepo = Mockito.mock(DoctorRepository.class);
        PatientRepository patientRepo = Mockito.mock(PatientRepository.class);
        AppointmentRepository appointmentRepo = Mockito.mock(AppointmentRepository.class);
        co.proyecto.sacm.integration.notifications.NotificationsClient notificationsClient = Mockito.mock(co.proyecto.sacm.integration.notifications.NotificationsClient.class);

        // Simula que el médico sí existe
        Mockito.when(doctorRepo.findById(anyLong())).thenReturn(Optional.of(Mockito.mock(co.proyecto.sacm.model.Doctor.class)));
        // Simula que el paciente no existe
        Mockito.when(patientRepo.findById(anyLong())).thenReturn(Optional.empty());

        // Instancia el servicio con los mocks y dependencias mínimas
        AppointmentService service = new AppointmentService(
                appointmentRepo, doctorRepo, patientRepo, null, notificationsClient
        );

        AppointmentRequestDTO req = new AppointmentRequestDTO();
        req.setDoctorId(1L);
        req.setPatientId(1L);

        // Verifica que se lanza la excepción
        assertThrows(BusinessException.class, () -> service.create(req));
    }

    @Test
    void debeCancelarCitaExistente() {
        // Mocks
        DoctorRepository doctorRepo = Mockito.mock(DoctorRepository.class);
        PatientRepository patientRepo = Mockito.mock(PatientRepository.class);
        AppointmentRepository appointmentRepo = Mockito.mock(AppointmentRepository.class);
        co.proyecto.sacm.integration.notifications.NotificationsClient notificationsClient = Mockito.mock(co.proyecto.sacm.integration.notifications.NotificationsClient.class);

        // Simula que la cita existe
        co.proyecto.sacm.model.Appointment appointment = Mockito.mock(co.proyecto.sacm.model.Appointment.class);
        Mockito.when(appointmentRepo.findById(1L)).thenReturn(Optional.of(appointment));

        AppointmentService service = new AppointmentService(
                appointmentRepo, doctorRepo, patientRepo, null, notificationsClient
        );

        // Ejecuta el método cancel
        service.cancel(1L);

        // Verifica que el estado de la cita se haya cambiado a CANCELLED
        Mockito.verify(appointment).setStatus(co.proyecto.sacm.model.enums.AppointmentStatus.CANCELLED);
        Mockito.verify(appointmentRepo).save(appointment);
        Mockito.verify(notificationsClient).sendAppointmentCancelled(1L, "user@example.com");
    }

    @Test
    void debeReprogramarCitaExistente() {
        // Mocks
        DoctorRepository doctorRepo = Mockito.mock(DoctorRepository.class);
        PatientRepository patientRepo = Mockito.mock(PatientRepository.class);
        AppointmentRepository appointmentRepo = Mockito.mock(AppointmentRepository.class);
        co.proyecto.sacm.integration.notifications.NotificationsClient notificationsClient = Mockito.mock(co.proyecto.sacm.integration.notifications.NotificationsClient.class);
        co.proyecto.sacm.service.AppointmentValidator validator = Mockito.mock(co.proyecto.sacm.service.AppointmentValidator.class);

        // Simula que la cita existe
        co.proyecto.sacm.model.Appointment appointment = Mockito.mock(co.proyecto.sacm.model.Appointment.class);
        Mockito.when(appointmentRepo.findById(1L)).thenReturn(Optional.of(appointment));

        AppointmentService service = new AppointmentService(
                appointmentRepo, doctorRepo, patientRepo, validator, notificationsClient
        );

        // Ejecuta el método reschedule
        java.time.LocalDateTime newStart = java.time.LocalDateTime.now().plusDays(2);
        service.reschedule(1L, newStart);

        // Verifica que el horario de la cita se haya actualizado
        Mockito.verify(validator).validateTimes(newStart, newStart.plusHours(1));
        Mockito.verify(validator).ensureNoOverlap(Mockito.any(), Mockito.eq(newStart), Mockito.eq(newStart.plusHours(1)));
        Mockito.verify(appointment).setStartAt(newStart);
        Mockito.verify(appointmentRepo).save(appointment);
    }

    @Test
    void debeConfirmarCitaExistente() {
        // Mocks
        DoctorRepository doctorRepo = Mockito.mock(DoctorRepository.class);
        PatientRepository patientRepo = Mockito.mock(PatientRepository.class);
        AppointmentRepository appointmentRepo = Mockito.mock(AppointmentRepository.class);
        co.proyecto.sacm.integration.notifications.NotificationsClient notificationsClient = Mockito.mock(co.proyecto.sacm.integration.notifications.NotificationsClient.class);

        // Simula que la cita existe
        co.proyecto.sacm.model.Appointment appointment = Mockito.mock(co.proyecto.sacm.model.Appointment.class);
        Mockito.when(appointmentRepo.findById(1L)).thenReturn(Optional.of(appointment));

        AppointmentService service = new AppointmentService(
                appointmentRepo, doctorRepo, patientRepo, null, notificationsClient
        );

        // Ejecuta el método confirm
        service.confirm(1L);

        // Verifica que el estado de la cita se haya cambiado a CONFIRMED
        Mockito.verify(appointment).setStatus(co.proyecto.sacm.model.enums.AppointmentStatus.CONFIRMED);
        Mockito.verify(appointmentRepo).save(appointment);
    }

    @Test
    void debeCompletarCitaExistente() {
        // Mocks
        DoctorRepository doctorRepo = Mockito.mock(DoctorRepository.class);
        PatientRepository patientRepo = Mockito.mock(PatientRepository.class);
        AppointmentRepository appointmentRepo = Mockito.mock(AppointmentRepository.class);
        co.proyecto.sacm.integration.notifications.NotificationsClient notificationsClient = Mockito.mock(co.proyecto.sacm.integration.notifications.NotificationsClient.class);

        // Simula que la cita existe
        co.proyecto.sacm.model.Appointment appointment = Mockito.mock(co.proyecto.sacm.model.Appointment.class);
        Mockito.when(appointmentRepo.findById(1L)).thenReturn(Optional.of(appointment));

        AppointmentService service = new AppointmentService(
                appointmentRepo, doctorRepo, patientRepo, null, notificationsClient
        );

        // Ejecuta el método complete
        service.complete(1L);

        // Verifica que el estado de la cita se haya cambiado a COMPLETED
        Mockito.verify(appointment).setStatus(co.proyecto.sacm.model.enums.AppointmentStatus.COMPLETED);
        Mockito.verify(appointmentRepo).save(appointment);
    }

}