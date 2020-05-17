import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet
import java.util.*

fun printTheStudent(rs: ResultSet) {
    if (rs.next()) {
        val name = rs.getString("name")
        val birthDate = rs.getDate("data_nastere")
        println("The student is $name, born on $birthDate.")
    } else {
        println("Student not found...")
    }
}

fun sqlInjection(conn: Connection, userInput: String) {
    val sql = "select nume || ' ' || prenume as name, data_nastere from studenti where nr_matricol = '$userInput'"
    println(sql)
    val statement = conn.createStatement()
    val rs = statement.executeQuery(sql)
    printTheStudent(rs)
}

fun noSqlInjection(conn: Connection, userInput: String) {
    val sql = "select nume || ' ' || prenume as name, data_nastere from studenti where nr_matricol = ?"
    val statement = conn.prepareStatement(sql)
    statement.setString(1, userInput)
    val rs = statement.executeQuery()
    printTheStudent(rs)
}

fun main() {
    val props = Properties()
    props["user"] = "student"
    props["password"] = "student"

    val conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", props)

    // normal usage
    sqlInjection(conn, "499GX0")
    noSqlInjection(conn, "499GX0")

    println()

    // malicious usage
    sqlInjection(conn, "x' or nume || ' ' || prenume = 'Cobuz Claudia")
    noSqlInjection(conn, "x' or nume || ' ' || prenume = 'Cobuz Claudia")
}