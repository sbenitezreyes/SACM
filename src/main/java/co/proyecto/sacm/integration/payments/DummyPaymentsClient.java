package co.proyecto.sacm.integration.payments;

import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
public class DummyPaymentsClient implements PaymentsClient {
    @Override
    public String createPayment(Long appointmentId, BigDecimal amount) {
        return "PAY-" + appointmentId; // dummy id
    }
    @Override
    public void refundPayment(String paymentId) {
        // no-op
    }
}
