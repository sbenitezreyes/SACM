package co.proyecto.sacm.dto;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
@Data
public class DoctorRequestDTO {
    @NotBlank private String fullName;
    @NotBlank private String specialty;
}
