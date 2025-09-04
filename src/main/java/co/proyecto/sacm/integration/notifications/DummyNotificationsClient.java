package co.proyecto.sacm.integration.notifications;

import org.springframework.stereotype.Component;

@Component
public class DummyNotificationsClient implements NotificationsClient {
    @Override
    public void sendAppointmentCreated(Long appointmentId, String toEmail) {
        // no-op
    }
    @Override
    public void sendAppointmentCancelled(Long appointmentId, String toEmail) {
        // no-op
    }
}
