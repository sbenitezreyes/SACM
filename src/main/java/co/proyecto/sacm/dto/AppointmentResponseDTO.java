package co.proyecto.sacm.dto;
import co.proyecto.sacm.model.enums.*;
import lombok.Builder;
import lombok.Value;

import java.time.LocalDateTime;

@Value @Builder
public class AppointmentResponseDTO {
    Long id;
    Long doctorId;
    Long patientId;
    LocalDateTime startAt;
    AppointmentStatus status;
    String notes;
}
