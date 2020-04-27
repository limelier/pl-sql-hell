import java.sql.*;

public class Main {
    public static void main(String[] args) throws SQLException {
        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "student", "student");
        CallableStatement stmt = conn.prepareCall("begin THROW_AN_EXCEPTION(); end;");
        try {
            stmt.execute();
        } catch (SQLException e) {
            if (e.getErrorCode() == 20001) {
                System.out.println("We got it!");
            } else {
                System.out.println("Uhh...");
            }
        }
        stmt.close();
        conn.close();
    }
}
