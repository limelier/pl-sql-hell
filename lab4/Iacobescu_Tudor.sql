-- Adaugati o coloana noua la tabelul studenti cu denumirea “lista_medii” de tip nested table in care se vor adauga mediile semestriale ale studentilor (din anul 1 sem 1, an 1 sem 2, an 2 sem 1 etc.). Campul de medii va fi extins doar cat este necesar (nu va contine decat locatii pentru mediile existente si nu 6 pentru fiecare medie posibil existenta). Mediile semestriale le puteti calcula grupand notele studentului dupa anul si semestrul in care au fost tinute curusurile la care are note. Construiti o functie care pentru un anumit student returneaza cate medii are trecute in coloana “lista_medii”.

-- facem tipul
create or replace type medii_semestriale is table of number(4, 2);

-- adaugam coloana la tabel
alter table studenti
    add (lista_medii medii_semestriale)
        nested table lista_medii store as medii_semestriale_table;

-- facem o functie pentru popularea tabelului
create or replace function get_medii_semestriale(s_id number)
    return medii_semestriale
    is
    medii medii_semestriale;
begin
    select avg(valoare)
        bulk collect
    into medii
    from note
             join cursuri on note.id_curs = cursuri.id
    where note.id_student = s_id
    group by cursuri.an, cursuri.semestru
    order by cursuri.an, cursuri.semestru;

    return medii;
end;

-- setam mediile la fiecare student folosind functia de mai devreme
declare
    medii medii_semestriale;
begin
    for stud in (select * from studenti)
        loop
            medii := get_medii_semestriale(stud.id);

            update studenti
            set studenti.lista_medii = medii
            where id = stud.id;
        end loop;
end;

-- cream functia de aflare a numarului de medii
create or replace function get_nr_medii(s_id number)
    return number
    is
    lista_med studenti.lista_medii%type;
begin
    select lista_medii into lista_med from studenti where id = s_id;
    return lista_med.count;
end;

-- testam functia
select get_nr_medii(2)
from dual;