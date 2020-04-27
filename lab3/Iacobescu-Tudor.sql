--Grupa A6
/*1.(1p) Avand exemplele trimise, creati un pachet pentru toate functiile trimise. Apelati apoi fiecare din aceste functii, in
cadrul pachetului.*/
    create or replace package pck_functii_trimise
is
    function get_scadenta(IN_data_scadenta date) return varchar2;
    function get_bursa_neta(IN_id studenti.id%type) return varchar2;
    function get_students_id return num_arr;
    function get_students_details return student_table;
    function get_repartitie_zodii return repartitie_zodii_table;
    function get_medii_intregi_prieteni(IN_id studenti.id%type) return medii_intregi_prieteni_table;
    function compara_studenti(IN_id1 studenti.id%type, IN_id2 studenti.id%type) return medii_studenti_table;
end pck_functii_trimise;

create or replace package body pck_functii_trimise
is
    function get_scadenta(IN_data_scadenta date)
        return varchar2
        is
        p_detail varchar2(100);
    begin
        if IN_data_scadenta = sysdate then
            p_detail := 'Data scadenta este azi';
        elsif IN_data_scadenta > sysdate then
            p_detail := 'Plata poate sa mai astepte';
        else
            p_detail := 'Sunteti in intarziere cu plata !';
        end if;
        return p_detail;
    end;

    function get_bursa_neta(IN_id studenti.id%type)
        return varchar2
        is
        p_impozit      number := 0;
        p_bursa_neta   number := 0;
        p_bursa        number := 0;
        p_detail       varchar2(200);
        p_exista_bursa number;
    begin
        select count(bursa) into p_exista_bursa from studenti where id = IN_id;
        if p_exista_bursa = 0 then
            p_detail := 'Studentul nu are bursa';
        else
            select bursa into p_bursa from studenti where id = IN_id;
            if p_bursa < 1000 then
                p_impozit := 0;
            elsif p_bursa between 1000 and 1099 then
                p_impozit := p_bursa * 0.1;
            elsif p_bursa between 1100 and 1199 then
                p_impozit := p_bursa * 0.2;
            elsif p_bursa >= 1200 then
                p_impozit := p_bursa * 0.4;
            end if;
            p_bursa_neta := p_bursa - p_impozit;
            p_detail := 'Studentul cu id-il' || IN_id || ' are bursa ' || p_bursa || ' si bursa neta de ' ||
                        p_bursa_neta;
        end if;
        return p_detail;
    END get_bursa_neta;
    function get_students_id
        return num_arr
        is
        p_students_id_arr num_arr;
    begin
        select student_id
            bulk collect
        into p_students_id_arr
        from (select s.id as student_id
              from studenti s
                       join note n on n.id_student = s.id
                       join cursuri c on c.id = n.id_curs
              where titlu_curs = 'Baze de date'
                and valoare = 10);
        return p_students_id_arr;
    end;
    function get_students_details
        return student_table
        is
        student_table_arr student_table := student_table();
    begin
        select student_object(student_id, student_nume, student_prenume)
            bulk collect
        into student_table_arr
        from (select s.id as student_id, s.nume as student_nume, s.prenume as student_prenume
              from studenti s
                       join note n on n.id_student = s.id
                       join cursuri c on c.id = n.id_curs
              where titlu_curs = 'Baze de date'
                and valoare = 10);
        return student_table_arr;
    end;
    function get_repartitie_zodii
        return repartitie_zodii_table
        is
        repartitie_zodii_table_arr repartitie_zodii_table := repartitie_zodii_table();
    begin
        select repartitie_zodii_object(nume_zodie, distributie)
            bulk collect
        into repartitie_zodii_table_arr
        from (select nume_zodie, count(*) as distributie
              from zodiac z
                       join studenti s
                            on to_date(to_char(s.data_nastere, 'DD-MM'), 'DD-MM') between to_date(z.data_inceput, 'DD-MM') and to_date(z.data_sfarsit, 'DD-MM')
              group by nume_zodie);
        return repartitie_zodii_table_arr;
    end;
    function get_medii_intregi_prieteni(IN_id studenti.id%type)
        return medii_intregi_prieteni_table
        is
        medii_intregi_prieteni_arr medii_intregi_prieteni_table := medii_intregi_prieteni_table();
    begin
        select medii_intregi_prieteni_object(id1, nume1, prenume1, medie1, medie_intreaga1, id2, nume2, prenume2,
                                             medie2,
                                             medie_intreaga2)
            bulk collect
        into medii_intregi_prieteni_arr
        from (select s1.id                     as id1,
                     s1.nume                   as nume1,
                     s1.prenume                as prenume1,
                     trunc(avg(n1.valoare), 2) as medie1,
                     trunc(avg(n1.valoare))    as medie_intreaga1,
                     s2.id                     as id2,
                     s2.nume                   as nume2,
                     s2.prenume                as prenume2,
                     trunc(avg(n2.valoare), 2) as medie2,
                     trunc(avg(n2.valoare))    as medie_intreaga2
              from studenti s1
                       join prieteni p on p.id_student1 = s1.id
                       join studenti s2 on s2.id = p.id_student2
                       join note n1 on s1.id = n1.id_student
                       join note n2 on s2.id = n2.id_student
              where id_student1 = IN_id
              group by s1.id, s1.nume, s1.prenume, s2.id, s2.nume, s2.prenume
              having trunc(avg(n1.valoare)) = trunc(avg(n2.valoare)));
        return medii_intregi_prieteni_arr;
    end;
    function compara_studenti(IN_id1 studenti.id%type, IN_id2 studenti.id%type)
        return
            medii_studenti_table
        is
        medii_studenti_arr medii_studenti_table := medii_studenti_table();
        p_castigator       varchar2(100);
    begin
        select medii_studenti_object(id_student1, nume_student1, prenume_student1, medie_student1, id_student2,
                                     nume_student2, prenume_student2, medie_student2)
            bulk collect
        into medii_studenti_arr
        from (select s1.id                     as id_student1,
                     s1.nume                   as nume_student1,
                     s1.prenume                as prenume_student1,
                     trunc(avg(n1.valoare), 2) as medie_student1,
                     s2.id                     as id_student2,
                     s2.nume                   as nume_student2,
                     s2.prenume                as prenume_student2,
                     trunc(avg(n2.valoare), 2) as medie_student2
              from studenti s1
                       join note n1 on s1.id = n1.id_student
                       join studenti s2 on s1.id <> s2.id
                       join note n2 on n2.id_student = s2.id
              where s1.id = IN_id1
                and s2.id = IN_id2
              group by s1.id, s1.nume, s1.prenume, s2.id, s2.nume, s2.prenume);
        return medii_studenti_arr;
    end;

    -- apel
end pck_functii_trimise;

select *
from table (pck_functii_trimise.get_repartitie_zodii)
order by 2 desc;


/*2.(1p) Modificati bursele din tabela studenti adaugind, cu ajutorul unei proceduri, la bursa existenta ultima
cifra a anului de nastere. Modificarea se va face pentru fiecare student ce are bursa !*/
create or replace procedure modif_burse
as
BEGIN
    update STUDENTI
    set bursa = bursa + mod(extract(YEAR from DATA_NASTERE), 10);
end modif_burse;

begin
    modif_burse();
end;

select *
from studenti
where bursa is not null;

/*3.(3p) Sa se scrie o functie care returneaza cursul (id, titlu_curs, nr_note) dintr-un an la care s-au pus cele mai putine note de 10, sau,
daca nu exista anul in baza de date, sa se returneze primul curs in ordinea id-urilor cu cele mai putine note in general.*/

create or replace type least10_ret is object
(
    id         number,
    titlu_curs varchar2(52),
    nr_note    number
);

create or replace type least10_ret_arr is table of least10_ret;

create or replace function existaAn(v_an number)
    return boolean
    is
    apar number;
begin
    select count(an) into apar from cursuri;
    if apar = 0 then
        return false;
    else
        return true;
    end if;
end;

create or replace function least10(v_an number)
    return least10_ret
    is
    returnval least10_ret;
begin
    if (existaAn(v_an)) then
        select least10_ret(id, titlu_curs, cnt)
        into returnval
        from (
                 select c.id as id, c.titlu_curs as titlu_curs, count(n.id) as cnt
                 from CURSURI c
                          join note n on c.ID = n.ID_CURS
                 where n.VALOARE = 10
                   and c.AN = v_an
                 group by c.id, c.titlu_curs
                 order by count(n.id)
             )
        where rownum = 1;
        return returnval;
    else
        select least10_ret(id, titlu_curs, cnt)
        into returnval
        from (
                 select c.id as id, c.titlu_curs as titlu_curs, count(n.id) as cnt
                 from CURSURI c
                          join note n on c.ID = n.ID_CURS
                 where n.VALOARE = 10
                 group by c.id, c.titlu_curs
                 order by count(n.id), c.id
             )
        where rownum = 1;
        return returnval;
    end if;
end;

select least10(2)
from dual;

select least10(4)
from dual;



