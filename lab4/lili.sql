-- Adaugati o coloana noua la tabelul studenti cu denumirea “lista_medii” de tip nested table in care se vor adauga mediile semestriale ale studentilor (din anul 1 sem 1, an 1 sem 2, an 2 sem 1 etc.). Campul de medii va fi extins doar cat este necesar (nu va contine decat locatii pentru mediile existente si nu 6 pentru fiecare medie posibil existenta). Mediile semestriale le puteti calcula grupand notele studentului dupa anul si semestrul in care au fost tinute curusurile la care are note. Construiti o functie care pentru un anumit student returneaza cate medii are trecute in coloana “lista_medii”.

create or replace type tabel_medii is table of number;

alter table studenti
    add (lista_medii2 tabel_medii)
        nested table lista_medii2 store as tabel_med;

select *
from studenti;

create or replace function get_medii(s_id number)
    return tabel_medii
    is
    medii tabel_medii;
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

select * from table (get_medii(1));

declare
    medii tabel_medii;
begin
    for stud in (select * from studenti)
        loop
            medii := get_medii(stud.id);
            update studenti
            set lista_medii2 = medii
            where id = stud.id;
        end loop;
end;

select *
from studenti;

create or replace function get_num_medii(s_id number)
return number
    is
    medii tabel_medii;
begin
    select lista_medii2
    into medii
    from studenti
    where id = s_id;
    return medii.count;
end;

select get_num_medii(1) from dual;