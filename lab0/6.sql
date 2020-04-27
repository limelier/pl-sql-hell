select max(id)
from PRIETENI;

drop sequence seq_nr_prieteni;

create sequence seq_nr_prieteni
    start with 20001
    increment by 1;

insert into prieteni (id, id_student1, id_student2)
select seq_nr_prieteni.nextval,
       (
           select id
           from STUDENTI
           where nume = 'Popescu'
             and prenume = 'Crina-Nicoleta'
       ),
       (
           select min(id)
           from STUDENTI
           where grupa = 'A4'
             and an = '2'
             and prenume like '%a'
       )
from DUAL;
