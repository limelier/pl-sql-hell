import java.lang.Exception
import java.sql.Connection
import java.sql.DriverManager
import java.sql.SQLException
import java.util.*

class BadCourseException : Exception("The given course name could not be found.")

data class CatalogEntry(
    val value: Int,
    val date: Date,
    val firstName: String,
    val lastName: String,
    val registrationNo: String
)

class Catalog(private val course: String) {
    private val conn: Connection

    init {
        val props = Properties()
        props["user"] = "student"
        props["password"] = "student"

        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", props)

        createTableIfMissing()
    }

    private fun getTableExists(): Boolean {
        val sql = "select count(1) from user_tables where table_name = ?"
        val stmt = conn.prepareStatement(sql)
        stmt.setString(1, course.toUpperCase().replace(" ", ""))
        val rs = stmt.executeQuery()
        rs.next()
        return rs.getInt(1) > 0
    }

    private fun getCourseId(): Int {
        val sql = "select id from cursuri where titlu_curs = ?"
        val stmt = conn.prepareStatement(sql)
        stmt.setString(1, course)
        val rs = stmt.executeQuery()
        rs.next()
        try {
            return rs.getInt(1)
        } catch (e: SQLException) {
            throw BadCourseException()
        }
    }

    private fun createTable() {
        val id = getCourseId()

        val sql = "begin catalog_materie(?); end;"
        val stmt = conn.prepareStatement(sql)
        stmt.setInt(1, id)
        stmt.execute()
        stmt.close()
    }

    private fun createTableIfMissing() {
        val exists = getTableExists()

        if (!exists) {
            createTable()
        }
    }

    fun getEntries(skip: Int, limit: Int): List<CatalogEntry> {
        val tableName = course.toUpperCase().replace(" ", "")

        val sql = """
            select *
            from (
                select c.*, rownum as rn
                from $tableName c
                where rownum <= ?
            )
            where rn > ?
        """.trimIndent()
//        val sql = "select * from (select c.*, rownum rn from $tableName c where rownum <= ?) where rn > ?"

        val stmt = conn.prepareStatement(sql)
        stmt.setInt(1, skip + limit)
        stmt.setInt(2, skip)

        val rs = stmt.executeQuery()

        val list = mutableListOf<CatalogEntry>()
        while (rs.next()) {
            list.add(
                CatalogEntry(
                    rs.getInt("VALOARE"),
                    rs.getDate("DATA_NOTARE"),
                    rs.getString("PRENUME"),
                    rs.getString("NUME"),
                    rs.getString("NR_MATRICOL")
                )
            )
        }
        stmt.close()
        return list.toList()
    }
}

const val pageSize = 10

fun getInput(catalog: Catalog, page: Int) {
    val hasPrev = page > 1
    if (hasPrev) {
        print("(p)revious page | ")
    }
    println("(n)ext page | anything else to quit")

    val input = readLine()
    when (input) {
        "p" -> {
            if (hasPrev) {
                printPage(catalog, page - 1)
            }
        }
        "n" -> printPage(catalog, page + 1)
    }
}

fun printPage(catalog: Catalog, page: Int) {
    val entries = catalog.getEntries(pageSize * (page - 1), pageSize)
    for (e in entries) {
        println("${e.registrationNo} | ${e.date} | ${e.value} | ${e.lastName} ${e.firstName}")
    }
    println()
    getInput(catalog, page)
}

fun main() {
    try {
        val catalog = Catalog("Calcul numeric")
        printPage(catalog, 1)
    } catch (err: BadCourseException) {
        print(err.message)
    }
}
