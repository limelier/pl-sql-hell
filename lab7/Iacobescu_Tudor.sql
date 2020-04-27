create or replace view catalog as
select s.nume       as last_name,
       s.prenume    as first_name,
       n.valoare    as value,
       c.titlu_curs as course
from studenti s
         join note n on s.id = n.id_student
         join cursuri c on n.id_curs = c.id;


create or replace trigger catalog_delete
    instead of delete
    on catalog
declare
    v_id_stud    studenti.id%type;
    v_id_curs    cursuri.id%type;
    v_count_stud number;
    v_count_curs number;
begin
    select id into v_id_stud from studenti where nume = :old.last_name and prenume = :old.first_name;
    select id into v_id_curs from cursuri where titlu_curs = :old.course;

    delete from note where id_student = v_id_stud and id_curs = v_id_curs;

    select count(*) into v_count_stud from note where id_student = v_id_stud;
    if (v_count_stud = 0)
    then
        delete from studenti where id = v_id_stud;
    end if;

    select count(*) into v_count_curs from note where id_curs = v_id_curs;
    if (v_count_curs = 0)
    then
        delete from didactic where id = v_id_curs;
        delete from cursuri where id = v_id_curs;
    end if;
end;


create or replace trigger catalog_insert
    instead of insert
    on catalog
declare
    v_count_stud    number;
    v_max_stud_id   number;
    v_stud_id       number;
    v_count_course  number;
    v_max_course_id number;
    v_course_id     number;
    v_max_grade_id  number;
    v_new_grade_id  number;
begin
    select count(*) into v_count_stud from studenti where nume = :new.last_name and prenume = :new.first_name;
    if (v_count_stud = 0)
    then
        select max(id) into v_max_stud_id from studenti;
        v_stud_id := v_max_stud_id + 1;
        insert into studenti
        values (v_stud_id,
                to_char(v_stud_id, '00000'),
                :new.last_name,
                :new.first_name,
                3,
                'A1',
                0,
                sysdate,
                null,
                sysdate,
                sysdate);
    else
        select id into v_stud_id from studenti where nume = :new.last_name and prenume = :new.first_name;
    end if;

    select count(*) into v_count_course from cursuri where titlu_curs = :new.course;
    if (v_count_course = 0)
    then
        select max(id) into v_max_course_id from cursuri;
        v_course_id := v_max_course_id + 1;
        insert into cursuri
        values (v_course_id,
                :new.course,
                1,
                1,
                5,
                sysdate,
                sysdate);
    else
        select id into v_course_id from cursuri where titlu_curs = :new.course;
    end if;

    select max(id) into v_max_grade_id from note;
    v_new_grade_id := v_max_grade_id + 1;
    insert into note
    values (v_new_grade_id,
            v_stud_id,
            v_course_id,
            :new.value,
            sysdate,
            sysdate,
            sysdate);
end;


create or replace trigger catalog_update
    instead of update
    on catalog
declare
    v_old_stud_id      number;
    v_old_course_id    number;
    v_count_new_stud   number;
    v_count_old_stud   number;
    v_max_stud_id      number;
    v_new_stud_id      number;
    v_count_new_course number;
    v_count_old_course number;
    v_max_course_id    number;
    v_new_course_id    number;
    v_max_grade_id     number;
    v_new_grade_id     number;
    v_new_grade_value  number;
begin
    if (:new.value > :old.value)
    then
        v_new_grade_value := :new.value;
    else
        v_new_grade_value := :old.value;
    end if;

    -- get student and course ids for old value
    select id into v_old_stud_id from studenti where nume = :old.last_name and prenume = :old.first_name;
    select id into v_old_course_id from cursuri where titlu_curs = :old.course;

    -- get student and course ids for updated value (insert if non-existant)
    select count(*) into v_count_new_stud from studenti where nume = :new.last_name and prenume = :new.first_name;
    if (v_count_new_stud = 0)
    then
        select max(id) into v_max_stud_id from studenti;
        v_new_stud_id := v_max_stud_id + 1;
        insert into studenti
        values (v_new_stud_id,
                to_char(v_new_stud_id, '00000'),
                :new.last_name,
                :new.first_name,
                3,
                'A1',
                0,
                sysdate,
                null,
                sysdate,
                sysdate);
    else
        select id into v_new_stud_id from studenti where nume = :new.last_name and prenume = :new.first_name;
    end if;

    select count(*) into v_count_new_course from cursuri where titlu_curs = :new.course;
    if (v_count_new_course = 0)
    then
        select max(id) into v_max_course_id from cursuri;
        v_new_course_id := v_max_course_id + 1;
        insert into cursuri
        values (v_new_course_id,
                :new.course,
                1,
                1,
                5,
                sysdate,
                sysdate);
    else
        select id into v_new_course_id from cursuri where titlu_curs = :new.course;
    end if;

    -- update the grade
    update note
    set id_student = v_new_stud_id,
        id_curs    = v_new_course_id,
        valoare    = v_new_grade_value,
        updated_at = sysdate
    where id_student = v_old_stud_id
      and id_curs = v_old_course_id;

    -- delete old students / courses that aren't needed anymore
    select count(*) into v_count_old_stud from note where id_student = v_old_stud_id;
    if (v_count_old_stud = 0)
    then
        delete from studenti where id = v_old_stud_id;
    end if;

    select count(*) into v_count_old_course from note where id_curs = v_old_course_id;
    if (v_count_old_course = 0)
    then
        delete from didactic where id = v_old_course_id;
        delete from cursuri where id = v_old_course_id;
    end if;
end;

-- testing
insert into catalog
values ('Iacobescu', 'Tudor', 8, 'Rocket Science');

select *
from catalog
where last_name = 'Iacobescu';

select *
from studenti
where nume = 'Iacobescu';

select *
from cursuri
where titlu_curs = 'Rocket Science';

update catalog
set first_name = 'Rodut',
    value = '6'
where last_name = 'Iacobescu';

delete
from catalog
where last_name = 'Iacobescu';
