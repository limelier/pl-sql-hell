-- init
drop table test_answers;
drop table test_entries;
drop table tests;
drop sequence tests_seq;
drop sequence test_entries_seq;
drop sequence test_answers_seq;

create table tests
(
    id    number primary key,
    email varchar2(100) unique,
    score number
);
create sequence tests_seq start with 1;

create table test_entries
(
    id              number primary key,
    test_id         number,
    question_id     varchar2(8),
    answered        number(1) default 0 not null,
    score           number,
    correct_answers number,
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
    test_exists              number;
    unanswered_entries_exist number;
    t_id                     number;
    t_score                  number;
    te_id                    number;
    q_id                     varchar2(8);
    q_text                   varchar2(1000);
    v_return                 varchar2(4000);
begin
    if mail is null
    then
        return '';
    end if;

    select count(*)
    into test_exists
    from tests
    where email = mail;

    if (test_exists = 0)
    then
        make_test(mail);
    end if;

    select id
    into t_id
    from tests
    where email = mail;

    if (answer is not null) then
        process_answer(t_id, answer);
    end if;

    select score
    into t_score
    from tests
    where id = t_id;

    select count(*)
    into unanswered_entries_exist
    from test_entries
    where test_id = t_id
      and answered = 0;

    if (unanswered_entries_exist > 0) then
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
    else
        return '{"result": ' || t_score || '}';
    end if;
end;

create or replace procedure process_answer(t_id number, answer varchar)
as
    q_id        varchar2(8);
    te_id       number;
    te_score    number;
    te_corr     number;
    te_answered number;
    ans_score   number;
    corr        varchar2(1);
    ans_right   number := 0;
    ans_wrong   number := 0;
begin
    -- 203:16,32,12
    q_id := regexp_substr(answer, 'Q[0-9]+', 1, 1);

    dbms_output.put_line(answer || ' ... ' || q_id);

    select id, score, correct_answers, answered
    into te_id, te_score, te_corr, te_answered
    from test_entries
    where question_id = q_id;

    if te_answered = 0
    then
        for ans in (
            select regexp_substr(answer, 'A[0-9]+', 1, level) as id
            from dual
            connect by regexp_substr(answer, 'A[0-9]+', 1, level) is not null
            )
            loop
                select corect
                into corr
                from raspunsuri
                where id = ans.id;

                if corr = '1'
                then
                    ans_right := ans_right + 1;
                else
                    ans_wrong := ans_wrong + 1;
                end if;
            end loop;
        ans_score := 10 / te_corr;
        te_score := ans_score * (ans_right - ans_wrong);
        if te_score < 0 then
            te_score := 0;
        end if;

        update test_entries
        set score    = te_score,
            answered = 1
        where id = te_id;
        update tests set score = score + te_score where id = t_id;
    end if;
end;

create
    or
    replace procedure make_test(mail varchar2) as
    v_q_id    varchar2(8);
    a_id      varchar2(8);
    t_id      number;
    te_id     number;
    v_cor_ans number;
begin
    t_id := tests_seq.nextval;
    insert into tests values (t_id, mail, 0);
    for i in 1..10
        loop
            v_q_id := get_random_new_question(t_id);
            te_id := test_entries_seq.nextval;
            insert into test_entries values (te_id, t_id, v_q_id, 0, null, null);

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

            v_cor_ans := 1;
            for ans in (
                select id, corect
                from (
                         select id, corect
                         from raspunsuri
                         where q_id = v_q_id
                           and not (id = a_id)
                         order by dbms_random.value()
                     )
                where rownum <= 5
                )
                loop
                    insert into test_answers values (test_answers_seq.nextval, te_id, ans.id);
                    if (ans.corect = '1') then
                        v_cor_ans := v_cor_ans + 1;
                    end if;
                end loop;

            update test_entries set correct_answers = v_cor_ans where id = te_id;
        end loop;
end;

create
    or
    replace function get_random_new_question(t_id number)
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
    v := next_question('test@test.test', 'Q16:A132,A133');
    dbms_output.put_line(v);
end;

select *
from test_entries
         join intrebari on question_id = intrebari.id
         join tests on test_entries.test_id = tests.id;

select *
from test_entries
         join test_answers ta on test_entries.id = ta.entry_id;

declare
    answer varchar2(1000) := 'Q14:A116,A113,A120,A118';
begin
    for ans in (
        select regexp_substr(answer, 'A[0-9]+', 1, level) as id
        from dual
        connect by regexp_substr(answer, 'A[0-9]+', 1, level) is not null
        )
        loop
            dbms_output.put_line(ans.id);
        end loop;
end;