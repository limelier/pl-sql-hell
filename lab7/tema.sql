create table note_logs
(
    username  varchar(50),
    grade_id  number,
    old_val   number,
    new_val   number,
    operation varchar(10),
    time      date
);

create or replace trigger note_log_update
    before update of valoare
    on note
    for each row
declare
    v_username varchar(50);
begin
    select user into v_username from dual;

    insert into note_logs
    values (v_username, :old.id, :old.valoare, :new.valoare, 'UPDATE', sysdate);
end;

create or replace trigger note_log_insert
    before insert
    on note
    for each row
declare
    v_username varchar(50);
begin
    select user into v_username from dual;

    insert into note_logs
    values (v_username, null, null, :new.valoare, 'INSERT', sysdate);
end;

create or replace trigger note_log_delete
    before delete
    on note
    for each row
declare
    v_username varchar(50);
begin
    select user into v_username from dual;

    insert into note_logs
    values (v_username, :old.id, :old.valoare, null, 'DELETE', sysdate);
end;

-- tests
insert into studenti
values (100000, '-', 'hello', 'world', 1, 'A1', null, sysdate, 'nobody@nowhere.com', sysdate, sysdate);

insert into cursuri
values (100000, '-', 1, 1, 1, sysdate, sysdate);


insert into note
values (100000, 100000, 100000, 10, sysdate, sysdate, sysdate);

update note
set valoare = 9
where id = 100000;

delete from note
where id = 100000;

select * from note_logs;