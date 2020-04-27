package sql;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Main {
    static String sql = "select nr_matricol, nume, prenume, email from studenti order by %s %s";
    static String compSql;
    static Statement stmt;

    final static String[] columnNames = {
            "Nr. Matricol",
            "Nume",
            "Prenume",
            "E-mail"
    };

    static void compileSql(String column, String order) {
        compSql = String.format(sql, column, order);
    }

    static List<List<Object>> getData(String orderColumn, String orderDirection) throws SQLException {
        compileSql(orderColumn, orderDirection);
        ResultSet rs = stmt.executeQuery(compSql);

        List<List<Object>> data = new ArrayList<>();

        while (rs.next()) {
            List<Object> line = new ArrayList<>();
            line.add(rs.getString(1));
            line.add(rs.getString(2));
            line.add(rs.getString(3));
            line.add(rs.getString(4));
            data.add(line);
        }

        return data;
    }

    static Object[][] toArr(List<List<Object>> list) {
        Object[][] arr = new Object[list.size()][list.get(0).size()];
        for (int i = 0; i < list.size(); i++) {
            for (int j = 0; j < list.get(0).size(); j++) {
                arr[i][j] = list.get(i).get(j);
            }
        }

        return arr;
    }

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        Connection conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe",
                "student",
                "student"
        );

        stmt = conn.createStatement();
        System.out.println(stmt.execute("select 2 from dual"));

        conn.close();
    }
}
