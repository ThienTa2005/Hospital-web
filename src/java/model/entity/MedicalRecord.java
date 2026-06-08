package model.entity;

public class MedicalRecord {
    private int recordId;
    private String diagnosis;
    private String notes;
    private String prescription;
    private int appointmentId;
    
    // --- [QUAN TRỌNG] Constructor rỗng chuẩn (Không được có lệnh throw) ---
    public MedicalRecord() {
    }

    // Constructor đầy đủ
    public MedicalRecord(int recordId, String diagnosis, String notes, String prescription, int appointmentId) {
        this.recordId = recordId;
        this.diagnosis = diagnosis;
        this.notes = notes;
        this.prescription = prescription;
        this.appointmentId = appointmentId;
    }

    // Getters and Setters
    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getPrescription() {
        return prescription;
    }

    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
}