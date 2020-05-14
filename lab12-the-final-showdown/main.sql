-- initialize sequences and tables
drop table test_answers;
drop table test_entries;
drop table tests;
drop sequence tests_seq;
drop sequence test_entries_seq;
drop sequence test_answers_seq;

-- tests table, stores one test for each email
create table tests
(
    id    number primary key,
    email varchar2(100) unique,
    score number -- total test score
);
create sequence tests_seq start with 1;

-- test entries table, stores the questions for each test
create table test_entries
(
    id              number primary key,
    test_id         number, -- test it belongs to
    question_id     varchar2(8), -- the id of the question it presents in INTREBARI
    answered        number(1) default 0 not null, -- 0 if not yet answered, 1 if already answered
    score           number, -- the score obtained for the question
    correct_answers number, -- the number of correct answers the test entry has, used for score calculation
    foreign key (test_id) references tests
);
create sequence test_entries_seq start with 1;

create table test_answers
(
    id        number primary key,
    entry_id  number, -- test entry with the question the answer is for
    answer_id varchar2(8), -- the id of the answer in RASPUNSURI
    foreign key (entry_id) references test_entries (id)
);
create sequence test_answers_seq start with 1;

-- clear after tests
delete
from test_answers;
delete
from test_entries;
delete
from tests;


-- main section

-- next_question function, as detailed on wiki
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
    -- stop immediately on null email
    if mail is null
    then
        return '';
    end if;

    -- if a test for the email doesn't exist, make one
    select count(*)
    into test_exists
    from tests
    where email = mail;

    if (test_exists = 0)
    then
        make_test(mail);
    end if;

    -- select the test
    select id
    into t_id
    from tests
    where email = mail;

    -- process an answer if one was given
    if (answer is not null) then
        process_answer(t_id, answer);
    end if;

    select score
    into t_score
    from tests
    where id = t_id;

    -- check if there are any questions left to answer
    select count(*)
    into unanswered_entries_exist
    from test_entries
    where test_id = t_id
      and answered = 0;

    if (unanswered_entries_exist > 0)
        -- if there are, return the JSON for one to the user
    then
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
        -- otherwise, return the score for the test
    else
        return '{"result": ' || t_score || '}';
    end if;
end;

-- process the given answer for the test; it is assumed that the answer references a real question in the test
--  and real answers to that question included in the given options
-- answer format: 'Q###:A###,A###,A###'
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
    -- get the question key, Q###
    q_id := regexp_substr(answer, 'Q[0-9]+', 1, 1);

    -- get info about the question (as a test_entry)
    select id, score, correct_answers, answered
    into te_id, te_score, te_corr, te_answered
    from test_entries
    where question_id = q_id;

    -- if it hasn't already been answered, we answer it with the given answer IDs
    if te_answered = 0
    then
        for ans in (
            -- select each A### answer id as a separate substring, feeding them into the loop
            select regexp_substr(answer, 'A[0-9]+', 1, level) as id
            from dual
            connect by regexp_substr(answer, 'A[0-9]+', 1, level) is not null
            )
            loop
                select corect
                into corr
                from raspunsuri
                where id = ans.id;

                -- the answer is added to the number of right or wrong answers, accordingly
                if corr = '1'
                then
                    ans_right := ans_right + 1;
                else
                    ans_wrong := ans_wrong + 1;
                end if;
            end loop;
        -- the total score is calculated based on the number of correct answers the test entry had
        ans_score := 10 / te_corr;
        te_score := ans_score * (ans_right - ans_wrong);
        if te_score < 0 then
            te_score := 0;
        end if;

        -- update the test entry and the score for the test as a whole
        update test_entries
        set score    = te_score,
            answered = 1
        where id = te_id;
        update tests set score = score + te_score where id = t_id;
    end if;
end;

-- make a test for the given e-mail
create or replace procedure make_test(mail varchar2) as
    v_q_id    varchar2(8);
    a_id      varchar2(8);
    t_id      number;
    te_id     number;
    v_cor_ans number;
begin
    -- get the new id, and insert a row into tests
    t_id := tests_seq.nextval;
    insert into tests values (t_id, mail, 0);
    for i in 1..10
        loop
            -- use get_random_new_question to get a question that is not in the test yet
            v_q_id := get_random_new_question(t_id);
            te_id := test_entries_seq.nextval;
            insert into test_entries values (te_id, t_id, v_q_id, 0, null, null);

            -- add one correct answer
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
            -- add 5 more random answers, avoiding duplicates
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

            -- update the test entry with the right number of correct answers
            update test_entries set correct_answers = v_cor_ans where id = te_id;
        end loop;
end;

-- get the id for a question in a domain not already in the test
create or replace function get_random_new_question(t_id number)
    return varchar2 as
    v_ret varchar2(8);
begin
    -- select one question from ...
    select id
    into v_ret
    from (
             -- ... questions with the domain not in...
             select id
             from intrebari
             where domeniu not in (
                 -- ... the domains of questions ...
                 select domeniu
                 from intrebari
                 where id in (
                     -- ... already in the test
                     select question_id
                     from test_entries
                     where test_id = t_id
                 )
             )
             order by dbms_random.value()
         )
    where rownum = 1;

    return v_ret;
end;


-- test - answer should be changed each test to test the entire functionality
declare
    v varchar2(4000);
begin
    v := next_question('test@test.test', '');
    -- example with answer:
--     v := next_question('test@test.test', 'Q6:A53,A52');
    dbms_output.put_line(v);
end;
