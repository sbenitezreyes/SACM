package co.proyecto.sacm.dto;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDateTime;
@Data
public class RescheduleRequestDTO {
    @NotNull @Future private LocalDateTime startAt;
    @NotNull @Future private LocalDateTime endAt;
}
