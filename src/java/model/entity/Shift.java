package model.entity;

import java.sql.Date;
import java.sql.Time;

public class Shift
{
    private int shiftId;
    private Date shiftDate;
    private Time startTime;
    private Time endTime;
    
    public Shift(int shiftId, Date shiftDate, Time startTime, Time endTime)
    {
        this.shiftId = shiftId;
        this.shiftDate = shiftDate;
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    public Shift(Date shiftDate, Time startTime, Time endTime)
    {
        this.shiftDate = shiftDate;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public int getShiftId()
    {
        return shiftId;
    }

    public Date getShiftDate()
    {
        return shiftDate;
    }

    public Time getStartTime()
    {
        return startTime;
    }

    public Time getEndTime()
    {
        return endTime;
    }

    public void setShiftId(int shiftId)
    {
        this.shiftId = shiftId;
    }

    public void setShiftDate(Date shiftDate)
    {
        this.shiftDate = shiftDate;
    }

    public void setStartTime(Time startTime)
    {
        this.startTime = startTime;
    }

    public void setEndTime(Time endTime)
    {
        this.endTime = endTime;
    }
    
    @Override
    public String toString()
    {
        return shiftId + " " + shiftDate + " " + startTime + " " + endTime;
    }
}