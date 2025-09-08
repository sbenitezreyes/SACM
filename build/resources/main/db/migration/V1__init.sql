CREATE TABLE doctors (
  doctor_id   BIGSERIAL PRIMARY KEY,
  full_name   VARCHAR(200) NOT NULL,
  specialty   VARCHAR(120) NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE patients (
  patient_id   BIGSERIAL PRIMARY KEY,
  full_name    VARCHAR(200) NOT NULL,
  document_id  VARCHAR(50)  NOT NULL UNIQUE,
  email        VARCHAR(320) NOT NULL UNIQUE,
  created_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE appointments (
  appointment_id BIGSERIAL PRIMARY KEY,
  doctor_id      BIGINT NOT NULL REFERENCES doctors(doctor_id),
  patient_id     BIGINT NOT NULL REFERENCES patients(patient_id),
  start_at       TIMESTAMP NOT NULL,
  end_at         TIMESTAMP NOT NULL,
  status         VARCHAR(20) NOT NULL,        -- REQUESTED/CONFIRMED/...
  payment_status VARCHAR(20) NOT NULL,        -- PENDING/PAID/...
  notes          TEXT,
  created_at     TIMESTAMPTZ DEFAULT now()
);

-- Índices útiles
CREATE INDEX ix_appt_doctor_time ON appointments(doctor_id, start_at, end_at);
CREATE INDEX ix_appt_patient_time ON appointments(patient_id, start_at);
