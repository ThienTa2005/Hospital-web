import java.sql.Connection;
import Utils.DBUtils;
public class DB {
    public static void main(String[] args) {
        // In thử dữ liệu từ users và patients
        DBUtils.printUsers();
        DBUtils.printPatients();
    }
}
