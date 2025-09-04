package co.proyecto.sacm.dto;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AppointmentRequestDTO {
    @NotNull @Min(1) private Long doctorId;
    @NotNull @Min(1) private Long patientId;
    @NotNull @Future private LocalDateTime startAt;
    @NotNull @Future private LocalDateTime endAt;
    private String notes;
}
