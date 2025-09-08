package co.proyecto.sacm.integration.notifications;

public interface NotificationsClient {
    void sendAppointmentCreated(Long appointmentId, String toEmail);
    void sendAppointmentCancelled(Long appointmentId, String toEmail);
}
