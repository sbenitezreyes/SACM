package co.proyecto.sacm.service;

import co.proyecto.sacm.dto.AppointmentRequestDTO;
import co.proyecto.sacm.dto.AppointmentResponseDTO;
import co.proyecto.sacm.model.*;
import co.proyecto.sacm.model.enums.AppointmentStatus;
import co.proyecto.sacm.model.enums.PaymentStatus;
import co.proyecto.sacm.exception.BusinessException;
import co.proyecto.sacm.integration.notifications.NotificationsClient;
import co.proyecto.sacm.integration.payments.PaymentsClient;
import co.proyecto.sacm.repository.AppointmentRepository;
import co.proyecto.sacm.repository.DoctorRepository;
import co.proyecto.sacm.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final DoctorRepository doctorRepository;
    private final PatientRepository patientRepository;
    private final AppointmentValidator validator;
    private final NotificationsClient notificationsClient; 
    private final PaymentsClient paymentsClient;           

    @Transactional
    public AppointmentResponseDTO create(AppointmentRequestDTO req) {
        Doctor doctor = doctorRepository.findById(req.getDoctorId())
                .orElseThrow(() -> new BusinessException("Médico no encontrado"));
        Patient patient = patientRepository.findById(req.getPatientId())
                .orElseThrow(() -> new BusinessException("Paciente no encontrado"));

        validator.validateTimes(req.getStartAt(), req.getEndAt());
        validator.ensureNoOverlap(doctor, req.getStartAt(), req.getEndAt());

        Appointment appt = Appointment.builder()
                .doctor(doctor).patient(patient)
                .startAt(req.getStartAt()).endAt(req.getEndAt())
                .status(AppointmentStatus.REQUESTED)
                .paymentStatus(PaymentStatus.PENDING)
                .notes(req.getNotes())
                .build();

        appt = appointmentRepository.save(appt);

        // Notificación mínima (si no quieres, comenta estas 2 líneas)
        notificationsClient.sendAppointmentCreated(appt.getId(), "user@example.com");

        return toDTO(appt);
    }

    @Transactional
    public void cancel(Long id) {
        var appt = appointmentRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Cita no existe"));
        appt.setStatus(AppointmentStatus.CANCELLED);
        appointmentRepository.save(appt);
        notificationsClient.sendAppointmentCancelled(appt.getId(), "user@example.com");
    }

    private AppointmentResponseDTO toDTO(Appointment a) {
        return AppointmentResponseDTO.builder()
                .id(a.getId())
                .doctorId(a.getDoctor().getId())
                .patientId(a.getPatient().getId())
                .startAt(a.getStartAt())
                .endAt(a.getEndAt())
                .status(a.getStatus())
                .paymentStatus(a.getPaymentStatus())
                .notes(a.getNotes())
                .build();
    }
    // métodos nuevos dentro de AppointmentService
    public AppointmentResponseDTO get(Long id) {
        return toDTO(appointmentRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Cita no existe")));
    }

    public void delete(Long id) {
        var a = appointmentRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Cita no existe"));
        appointmentRepository.delete(a);
    }

    @Transactional
    public AppointmentResponseDTO reschedule(Long id, LocalDateTime start, LocalDateTime end) {
        var a = appointmentRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Cita no existe"));
        validator.validateTimes(start, end);
        validator.ensureNoOverlap(a.getDoctor(), start, end);
        a.setStartAt(start);
        a.setEndAt(end);
        return toDTO(appointmentRepository.save(a));
    }

    @Transactional
    public AppointmentResponseDTO confirm(Long id) {
        var a = appointmentRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Cita no existe"));
        a.setStatus(co.proyecto.sacm.model.enums.AppointmentStatus.CONFIRMED);
        return toDTO(appointmentRepository.save(a));
    }

    @Transactional
    public AppointmentResponseDTO complete(Long id) {
        var a = appointmentRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Cita no existe"));
        a.setStatus(co.proyecto.sacm.model.enums.AppointmentStatus.COMPLETED);
        return toDTO(appointmentRepository.save(a));
    }

    // listas de apoyo
    public List<AppointmentResponseDTO> listByDoctorAndDay(Long doctorId, LocalDateTime from, LocalDateTime to){
        return appointmentRepository.findByDoctorIdAndStartAtBetween(doctorId, from, to)
                .stream().map(this::toDTO).toList();
    }
    public List<AppointmentResponseDTO> listByPatient(Long patientId){
        return appointmentRepository.findByPatientIdOrderByStartAtDesc(patientId)
                .stream().map(this::toDTO).toList();
    }

}
