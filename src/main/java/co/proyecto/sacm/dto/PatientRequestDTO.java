package co.proyecto.sacm.dto;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
@Data
public class PatientRequestDTO {
    @NotBlank private String fullName;
    private String documentId;
    @Email @NotBlank private String email;
}
