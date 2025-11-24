package model.entity;

public class MedicalRecord
{
    private int recordId;
    private String diagnosis, notes, prescription;
    private int appointmentId;
    
    public MedicalRecord(int recordId, String diagnosis, String notes, String prescription, int appointmentId)
    {
        this.recordId = recordId;
        this.diagnosis = diagnosis;
        this.notes = notes;
        this.prescription = prescription;
        this.appointmentId = appointmentId;
    }

    public int getRecordId()
    {
        return recordId;
    }

    public String getDiagnosis()
    {
        return diagnosis;
    }

    public String getNotes()
    {
        return notes;
    }

    public String getPrescription()
    {
        return prescription;
    }

    public int getAppointmentId()
    {
        return appointmentId;
    }

    public void setRecordId(int recordId)
    {
        this.recordId = recordId;
    }

    public void setDiagnosis(String diagnosis)
    {
        this.diagnosis = diagnosis;
    }

    public void setNotes(String notes)
    {
        this.notes = notes;
    }

    public void setPrescription(String prescription)
    {
        this.prescription = prescription;
    }

    public void setAppointmentId(int appointmentId)
    {
        this.appointmentId = appointmentId;
    }
}