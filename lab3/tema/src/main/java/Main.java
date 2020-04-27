import org.json.*;
import java.sql.*;
import java.util.Scanner;

public class Main {
    private static int getId(Statement stmt) throws SQLException {
        Scanner scan = new Scanner(System.in);
        String nume = scan.next();
        String prenume = scan.next();
        String grupa = scan.next();
        int an = scan.nextInt();

        String sql1 = "select id from studenti where nume = '%s' and prenume = '%s' and grupa = '%s' and an = %d";
//        String psql1 = String.format(sql1, "Silitra", "Andreia Emma", "B3", "3");
        String psql1 = String.format(sql1, nume, prenume, grupa, an);
        ResultSet rs = stmt.executeQuery(psql1);

        int id = 1;
        if (rs.next()) {
            id = rs.getInt(1);
        }
        return id;
    }

    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        JSONObject obj;

        DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());


        Connection conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe",
                "student",
                "student"
        );

        Statement stmt = conn.createStatement();



        int id = getId(stmt);
        System.out.println(id);

        ResultSet rs = stmt.executeQuery(String.format("select get_recommended_friends(%d) from dual", id));

        if (rs.next()) {
            String str = rs.getString(1);
            obj = new JSONObject(str);
            System.out.println(obj.toString(4));
        }
    }
}
