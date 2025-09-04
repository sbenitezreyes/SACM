package co.proyecto.sacm.integration.payments;

import java.math.BigDecimal;

public interface PaymentsClient {
    String createPayment(Long appointmentId, BigDecimal amount);
    void refundPayment(String paymentId);
}
