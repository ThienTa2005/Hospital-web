package model.entity;

import java.sql.Timestamp;

public class Test
{
    private int testId;
    private String name;
    private Timestamp testTime;
    private String parameter, parameterValue;
    private String unit, referenceRange;
    private int appointmentId, shiftDoctorId;
    
    public Test(int testId, String name, Timestamp testTime, String parameter, String parameterValue, String unit, String referenceRange, int appointmentId, int shiftDoctorId)
    {
        this.testId = testId;
        this.name = name;
        this.testTime = testTime;
        this.parameter = parameter;
        this.parameterValue = parameterValue;
        this.unit = unit;
        this.referenceRange = referenceRange;
        this.appointmentId = appointmentId;
        this.shiftDoctorId = shiftDoctorId;
    }

    public int getTestId()
    {
        return testId;
    }

    public String getName()
    {
        return name;
    }

    public Timestamp getTestTime()
    {
        return testTime;
    }

    public String getParameter()
    {
        return parameter;
    }

    public String getParameterValue()
    {
        return parameterValue;
    }

    public String getUnit()
    {
        return unit;
    }

    public String getReferenceRange()
    {
        return referenceRange;
    }

    public int getAppointmentId()
    {
        return appointmentId;
    }

    public int getShiftDoctorId()
    {
        return shiftDoctorId;
    }

    public void setTestId(int testId)
    {
        this.testId = testId;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public void setTestTime(Timestamp testTime)
    {
        this.testTime = testTime;
    }

    public void setParameter(String parameter)
    {
        this.parameter = parameter;
    }

    public void setParameterValue(String parameterValue)
    {
        this.parameterValue = parameterValue;
    }

    public void setUnit(String unit)
    {
        this.unit = unit;
    }

    public void setReferenceRange(String referenceRange)
    {
        this.referenceRange = referenceRange;
    }

    public void setAppointmentId(int appointmentId)
    {
        this.appointmentId = appointmentId;
    }

    public void setShiftDoctorId(int shiftDoctorId)
    {
        this.shiftDoctorId = shiftDoctorId;
    }
}
