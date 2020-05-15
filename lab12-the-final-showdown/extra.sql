create table test_users (
    hash char(64) primary key,
    email varchar2(100)
);

create table next_question_call_logs (
    mail varchar2(100),
    answer varchar2(1000),
    time date
);