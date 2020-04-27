import cx_Oracle

try:
    con = cx_Oracle.connect('student/student@localhost/xe')
    cursor = con.cursor()
    
    cursor.execute("""
    select nume, prenume
    from studenti
    where an = 2
        and grupa = 'B2'
        and bursa is not null
    """)

    for result in cursor:
        print(result)
except cx_Oracle.DatabaseError as e:
    print('Error occured with Oracle: ', e)
finally: 
    if cursor: 
        cursor.close() 
    if con: 
        con.close() 
