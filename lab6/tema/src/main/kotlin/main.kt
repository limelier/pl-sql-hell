import oracle.jdbc.OracleStruct
import java.sql.Connection
import java.sql.DriverManager
import java.util.*

data class Person (val name: String, val surname: String)

class PersonRepo (private val conn: Connection) {
    fun save(person: Person) {
        val sql = "insert into persons values (0, person('${person.name}', '${person.surname}'))"
        conn.createStatement().execute(sql)
    }

    fun loadAll() : List<Person> {
        val sql = "select * from persons"
        val rs = conn.createStatement().executeQuery(sql)

        val list = mutableListOf<Person>()
        while (rs.next()) {
            val personAttr = (rs.getObject("person") as OracleStruct).attributes
            list.add(Person(personAttr[0] as String, personAttr[1] as String))
        }

        return list.toList()
    }
    fun deleteAll() {
        val sql = "delete from persons"
        conn.createStatement().execute(sql)
    }
}

fun main() {
    val props = Properties()
    props["user"] = "student"
    props["password"] = "student"

    val conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", props)
    val repo = PersonRepo(conn)

    repo.deleteAll()

    val personsTo = listOf(
        Person("John", "Doe"),
        Person("Jane", "Doe")
    )

    for (person in personsTo) {
        repo.save(person)
    }

    val personsFrom = repo.loadAll()
    println(personsFrom)
}
