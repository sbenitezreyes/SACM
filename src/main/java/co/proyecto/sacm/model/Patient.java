package co.proyecto.sacm.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;

@Entity
@Table(name = "patients")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "patient_id")              // <- clave: mapea la PK real
    private Long id;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "document_id", nullable = false, unique = true)
    private String documentId;

    @Column(nullable = false, unique = true)
    private String email;

    
}
