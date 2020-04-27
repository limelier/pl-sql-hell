-- Dupa cum puteti observa din scriptul de creare, toti studentii au note la materia logica. Asta inseamna ca o noua nota nu ar trebui sa fie posibil sa fie inserata pentru un student si pentru aceasta materie (nu poti avea doua note la aceeasi materie). Construiti o constrangere care sa arunce o exceptie cand regula de mai sus este incalcata (poate fi unicitate pe campurile id_student+id_curs, index unique peste aceleasi doua campuri sau cheie primara peste cele doua).
--
-- Prin intermediul unui script PLSQL incercati de 1 milion de ori sa inserati o nota la materia logica. Pentru aceasta aveti doua metode:
-- - sa vedeti daca exista nota (cu count, cum deja ati mai facut) pentru studentul X la logica si sa inserati doar daca nu exista.
-- - sa incercati sa inserati si sa prindeti exceptia in caz ca aceasta este aruncata.
-- Implementati ambele metode si observati timpii de executie pentru fiecare dintre ele. (3pct)

--
-- Construiti o functie PLSQL care sa primeasca ca parametri numele si prenumele unui student si care sa returneze media si, in caz ca nu exista acel student (dat prin nume si prenume) sa arunce o exceptie definita de voi. Dintr-un bloc anonim care contine intr-o structura de tip colectie mai multe nume si prenume (trei studenti existenti si trei care nu sunt in baza de date), apelati functia cu diverse valori. Prindeti exceptia si afisati un mesaj corespunzator atunci cand studentul nu exista sau afisati valoarea returnata de functie daca studentul exista. (2pct)


-- add constraint
alter table note
    add constraint unique_note unique (id_curs, id_student);

-- functie ajutatoare: rand student (ineficienta, dar consistenta)
create or replace function rand_stud_id
    return number
    is
    num_studs number;
    rand_val  number;
    id_stud   number;
begin
    select count(*)
    into num_studs
    from studenti;

    rand_val := trunc(dbms_random.VALUE(1, num_studs));

    select id
    into id_stud
    from (
             select id, rownum as rand
             from studenti
         )
    where rand = rand_val;

    return id_stud;
end;

-- functie ajutatoare: insert nota la logica
create or replace procedure insert_nota_la_logica(s_id number)
    is
    max_id    number;
    n_id      number;
    n_id_curs number := 1; -- logica
    n_valoare number := 10;
begin
    select max(id)
    into max_id
    from note;

    n_id := max_id + 1;
    insert into note
    values (n_id, s_id, n_id_curs, n_valoare, sysdate, sysdate, sysdate);
end;


-- metoda 1
declare
    s_id        number;
    exista_nota number;
begin
    for i in 1..1000000
        loop
            s_id := rand_stud_id();

            select count(*)
            into exista_nota
            from note
            where id_student = s_id
              and id_curs = 1; -- logica

            if (exista_nota = 0) then
                insert_nota_la_logica(s_id);
            end if;
        end loop;
end;
-- completed in 7 m 5 s 216 ms

-- metoda 2
-- functie ajutatoare
create or replace procedure maybe_ins_rand_nota_la_logica
    is
    s_id number;
begin
    s_id := rand_stud_id();
    insert_nota_la_logica(s_id);
exception
    when dup_val_on_index
        then return;
end;


-- testul propriu-zis
declare
    s_id number;
begin
    for i in 1..1000000
        loop
            maybe_ins_rand_nota_la_logica();
        end loop;
end;
-- completed in 11 m 1 s 933 ms

-- concluzie: exceptiile nu trebuie folosite in codul normal, ci doar in situatii de exceptie

----------------

create or replace function get_id_from_fullname(s_nume studenti.nume%type, s_prenume studenti.prenume%type)
    return number
as
    s_id number;
    student_inexistent exception;
    pragma exception_init ( student_inexistent, -20001 );
begin
    select id
    into s_id
    from studenti
    where nume = s_nume
      and prenume = s_prenume;

    return s_id;
exception
    when no_data_found then
        raise_application_error(-20001, 'Studentul dat nu exista!');
        return null;
end;

create or replace function get_media(s_nume studenti.nume%type, s_prenume studenti.prenume%type)
    return number
as
    average number;
    s_id    number;
    student_inexistent exception;
    pragma exception_init ( student_inexistent, -20001 );
begin
    s_id := get_id_from_fullname(s_nume, s_prenume);

    select avg(valoare)
    into average
    from note
    where id_student = s_id;

    return average;
end;

declare
    type t_fullname is record (nume studenti.nume%type, prenume studenti.prenume%type);
    type t_fullnames is table of t_fullname;
    s_fullnames t_fullnames := t_fullnames();
    stud        t_fullname;
    s_medie     number;

    student_inexistent exception;
    pragma exception_init ( student_inexistent, -20001 );
begin
    s_fullnames.extend(6);
    s_fullnames(1).nume := 'Iordache'; s_fullnames(1).prenume := 'Vasilica';
    s_fullnames(2).nume := 'Strimtu'; s_fullnames(2).prenume := 'Elisa Xena';
    s_fullnames(3).nume := 'Irimia'; s_fullnames(3).prenume := 'Teodor Nicu';
    s_fullnames(4).nume := 'Iacobescu'; s_fullnames(4).prenume := 'Tudor';
    s_fullnames(5).nume := 'Cernat'; s_fullnames(5).prenume := 'Monica Roxana';
    s_fullnames(6).nume := 'XXXXXXXXXX'; s_fullnames(6).prenume := 'YYYYYYYYYYY';

    for i in s_fullnames.first..s_fullnames.last
        loop
            stud := s_fullnames(i);

            s_medie := get_media(stud.nume, stud.prenume);
            dbms_output.PUT_LINE('Media studentului ' || stud.nume || ' ' || stud.prenume || ' este ' || s_medie);
        end loop;

exception
    when student_inexistent then
        dbms_output.PUT_LINE('Studentul ' || stud.nume || ' ' || stud.prenume || ' nu exista!');
end;

