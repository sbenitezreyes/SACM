package co.proyecto.sacm.service;

import co.proyecto.sacm.dto.DoctorRequestDTO;
import co.proyecto.sacm.exception.BusinessException;
import co.proyecto.sacm.model.Doctor;
import co.proyecto.sacm.repository.DoctorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DoctorService {

    private final DoctorRepository doctorRepository;

    @Transactional
    public Doctor create(Doctor d) {
        return doctorRepository.save(d);
    }

    public List<Doctor> list() {
        return doctorRepository.findAll();
    }

    public Doctor get(Long id) {
        return doctorRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Médico no encontrado"));
    }

    @Transactional
    public Doctor update(Long id, Doctor data) {
        Doctor d = get(id);
        d.setFullName(data.getFullName());
        d.setSpecialty(data.getSpecialty());
        return doctorRepository.save(d);
    }

    @Transactional
    public void delete(Long id) {
        doctorRepository.delete(get(id));
    }
}
