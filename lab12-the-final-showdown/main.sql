-- init
drop table tests;
drop table test_entries;
drop table test_answers;

create table tests
(
    id    number primary key,
    email varchar2(100) unique,
    score number
);
create sequence tests_seq start with 1;

create table test_entries
(
    id          number primary key,
    test_id     number,
    question_id varchar2(8),
    answered    number(1) default 0 not null,
    score       number,
    foreign key (test_id) references tests
);
create sequence test_entries_seq start with 1;

create table test_answers
(
    id        number primary key,
    entry_id  number,
    answer_id varchar2(8),
    foreign key (entry_id) references test_entries (id)
);
create sequence test_answers_seq start with 1;

-- clear
delete
from test_answers;
delete
from test_entries;
delete
from tests;

-- main
create or replace function next_question(mail varchar2, answer varchar2) return varchar2 as
    test_exists number;
    t_id        number;
    te_id       number;
    q_id        varchar2(8);
    q_text      varchar2(1000);
    v_return    varchar2(4000);
begin
    if mail is null
    then
        return '';
    end if;

    select count(*)
    into test_exists
    from tests
    where email = mail;

    if (test_exists < 0)
    then
        make_test(mail);
    end if;

    select id
    into t_id
    from tests
    where email = mail;

    select id, question_id
    into te_id, q_id
    from test_entries
    where test_id = t_id
      and answered = 0
      and rownum = 1;

    select text_intrebare
    into q_text
    from intrebari
    where id = q_id;

    v_return := '{' ||
                '"q_id": "' || q_id || '",' ||
                '"q_text": "' || q_text || '",' ||
                '"answers": [';

    for ans in (
        select t_a.answer_id as id, a.text_raspuns as text
        from test_answers t_a
                 join raspunsuri a on t_a.answer_id = a.id
        where t_a.entry_id = te_id
        order by dbms_random.value()
        )
        loop
            v_return := v_return || '{' ||
                        '"a_id": "' || ans.id || '",' ||
                        '"a_text": "' || ans.text || '"' ||
                        '},';
        end loop;

    v_return := substr(v_return, 1, (length(v_return) - 1));
    v_return := v_return || '}]';
    return v_return;
end;

create or replace procedure make_test(mail varchar2) as
    v_q_id varchar2(8);
    a_id   varchar2(8);
    t_id   number;
    te_id  number;
begin
    t_id := tests_seq.nextval;
    insert into tests values (t_id, mail, 0);
    for i in 1..10
        loop
            v_q_id := get_random_new_question(t_id);
            te_id := test_entries_seq.nextval;
            insert into test_entries values (te_id, t_id, v_q_id, 0, 0);

            select id
            into a_id
            from (
                     select id
                     from raspunsuri
                     where q_id = v_q_id
                       and corect = '1'
                     order by dbms_random.value()
                 )
            where rownum = 1;
            insert into test_answers values (test_answers_seq.nextval, te_id, a_id);

            for ans in (
                select id
                from (
                         select id
                         from raspunsuri
                         where q_id = v_q_id
                           and not (id = a_id)
                         order by dbms_random.value()
                     )
                where rownum <= 5
                )
                loop
                    insert into test_answers values (test_answers_seq.nextval, te_id, ans.id);
                end loop;
        end loop;
end;

create or replace function get_random_new_question(t_id number)
    return varchar2 as
    v_ret varchar2(8);
begin
    select id
    into v_ret
    from intrebari
    where domeniu not in (
        select domeniu
        from intrebari
        where id in (
            select question_id
            from test_entries
            where test_id = t_id
        )
    )
      and rownum = 1;
    return v_ret;
end;

declare
    v varchar2(4000);
begin
--     make_test('test@test.test');
    v := next_question('test@test.test', null);
    dbms_output.put_line(v);
end;

select *
from test_entries
         join intrebari on question_id = intrebari.id
         join tests on test_entries.test_id = tests.id;

select *
from test_entries
         join test_answers ta on test_entries.id = ta.entry_id;