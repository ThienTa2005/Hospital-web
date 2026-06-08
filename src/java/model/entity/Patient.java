package model.entity;

public class Patient extends User {
    // Constructor
    public Patient() {
        super(); // Gọi constructor của class cha (User)
        // Dùng setter để gán giá trị cho trường private của cha
        setRole("patient"); 
    }
}