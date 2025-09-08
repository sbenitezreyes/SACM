package co.proyecto.sacm.service;

import co.proyecto.sacm.model.Patient;
import co.proyecto.sacm.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PatientService {
    private final PatientRepository patientRepository;

    @Transactional
    public Patient create(Patient p) {
        return patientRepository.save(p);
    }

    public List<Patient> list() {
        return patientRepository.findAll();
    }

    public Patient get(Long id) {
        return patientRepository.findById(id).orElse(null);
    }

    @Transactional
    public Patient update(Long id, Patient data) {
        Patient p = get(id);
        p.setFullName(data.getFullName());
        p.setEmail(data.getEmail());
        return patientRepository.save(p);
    }

    @Transactional
    public void delete(Long id) {
        patientRepository.deleteById(id);
    }
}
