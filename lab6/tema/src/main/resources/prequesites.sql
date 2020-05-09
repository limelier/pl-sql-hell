create or replace type person is object
(
    name    varchar2(20),
    surname varchar2(40)
);

create sequence person_id start with 1;

create table persons
(
    id     number(10) primary key,
    person person
);

create or replace trigger person_id
    before insert
    on persons
    for each row
begin
    select person_id.nextval
    into :new.id
    from dual;
end;