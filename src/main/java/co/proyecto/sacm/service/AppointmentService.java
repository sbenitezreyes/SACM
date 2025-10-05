package co.proyecto.sacm.service;

import co.proyecto.sacm.dto.AppointmentRequestDTO;
import co.proyecto.sacm.dto.AppointmentResponseDTO;
import co.proyecto.sacm.model.*;
import co.proyecto.sacm.model.enums.AppointmentStatus;
import co.proyecto.sacm.exception.BusinessException;
import co.proyecto.sacm.integration.notifications.NotificationsClient;
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

    @Transactional
    public AppointmentResponseDTO create(AppointmentRequestDTO req) {
        Doctor doctor = doctorRepository.findById(req.getDoctorId())
                .orElseThrow(() -> new BusinessException("Médico no encontrado"));
        Patient patient = patientRepository.findById(req.getPatientId())
                .orElseThrow(() -> new BusinessException("Paciente no encontrado"));

        validator.validateTimes(req.getStartAt(), req.getStartAt().plusHours(1));
        validator.ensureNoOverlap(doctor, req.getStartAt(), req.getStartAt().plusHours(1));

        Appointment appt = Appointment.builder()
                .doctor(doctor).patient(patient)
                .startAt(req.getStartAt())
                .status(AppointmentStatus.REQUESTED)
                .notes(req.getNotes())
                .build();

        appt = appointmentRepository.save(appt);

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
                .status(a.getStatus())
                .notes(a.getNotes())
                .build();
    }

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
    public AppointmentResponseDTO reschedule(Long id, LocalDateTime start) {
        var a = appointmentRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Cita no existe"));
        validator.validateTimes(start, start.plusHours(1));
        validator.ensureNoOverlap(a.getDoctor(), start, start.plusHours(1));
        a.setStartAt(start);
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

    public List<AppointmentResponseDTO> listByDoctorAndDay(Long doctorId, LocalDateTime from, LocalDateTime to){
        return appointmentRepository.findByDoctorIdAndStartAtBetween(doctorId, from, to)
                .stream().map(this::toDTO).toList();
    }
    public List<AppointmentResponseDTO> listByPatient(Long patientId){
        return appointmentRepository.findByPatientIdOrderByStartAtDesc(patientId)
                .stream().map(this::toDTO).toList();
    }
    public List<AppointmentResponseDTO> listAll() {
        return appointmentRepository.findAll()
                .stream().map(this::toDTO).toList();
    }

}
