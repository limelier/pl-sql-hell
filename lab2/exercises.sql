/*1. Avand o variabila de tip varchar2 ce contine un sir de caractere
(initializarea se va face in blocul de declaratii a variabilelor), sa se numere
cate vocale contine textul.*/
--varianta 1 (cu while / for / loop) - 1 punct

set serveroutput on;
declare
    v_characters VARCHAR2(200) := 'hello, world';
    v_character  CHAR(1);
    v_no_vowels  NUMBER        := 0;
begin
    while (length(v_characters) > 0)
        loop
            v_character := substr(v_characters, 1, 1);
            if upper(v_character) in ('A', 'E', 'I', 'O', 'U')
            then
                v_no_vowels := v_no_vowels + 1;
            end if;
            v_characters := substr(v_characters, 2);
        end loop;
    DBMS_OUTPUT.PUT_LINE(v_no_vowels);
end;

--varianta 2 (cu while / for / loop) - 1 punct
set serveroutput on;
declare
    v_characters VARCHAR2(200) := 'hello, world';
    v_character  CHAR(1);
    v_no_vowels  NUMBER        := 0;
begin
    for i in 1..length(v_characters)
        loop
            v_character := substr(v_characters, i, 1);
            if upper(v_character) in ('A', 'E', 'I', 'O', 'U')
            then
                v_no_vowels := v_no_vowels + 1;
            end if;
        end loop;
    dbms_output.put_line(v_no_vowels);
end;

/*2.Scrieti un bloc anonim care sa afiseze numerele intregi pozitive si divizibile cu 3, pana la o valoare n, care se da de la tastatura*/
--1 punct
accept n prompt 'Dati valoarea:'

declare
    v_n NUMBER := &n;
    v_i NUMBER := 0;
begin
    while v_i < v_n
        loop
            DBMS_OUTPUT.PUT_LINE(v_i);
            v_i := v_i + 3;
        end loop;
end;

/*3. Utilizand tabela cursuri, valoarea unui curs se poate calcula ca fiind nr de studenti ce au note la acel curs raportat
la numarul de credite. Sa se gaseasca cursul cel mai valoros dintr-un an care este dat ca parametru*/
--2 puncte
accept an prompt 'Give the year:'

declare
    v_year   NUMBER := &n;
    v_course CURSURI.TITLU_CURS%TYPE;
begin
    select course
    into v_course
    from (
             select c.TITLU_CURS as course
             from CURSURI c
                      join NOTE n on c.ID = n.ID_CURS
             group by c.TITLU_CURS, c.an, c.credite
             having c.an = v_year
             order by count(n.id) / c.CREDITE desc
         )
    where rownum = 1;

    DBMS_OUTPUT.PUT_LINE(v_course);
end;

-- alt - allows for ties:
accept an prompt 'Give the year:'

declare
    cursor v_course_cursor (p_year number) is
        select c.TITLU_CURS, count(n.id) / c.CREDITE as raport
        from CURSURI c
                 join NOTE n on c.ID = n.ID_CURS
        group by c.TITLU_CURS, c.an, c.credite
        having c.an = p_year
        order by count(n.id) / c.CREDITE desc;
    v_course cursuri.titlu_curs%type;
    v_raport number;
    v_raport_max number := -1;
begin
    open v_course_cursor (&an);
    loop
        fetch v_course_cursor into v_course, v_raport;
        if v_raport >= v_raport_max
            then
                DBMS_OUTPUT.PUT_LINE(v_course);
                v_raport_max := v_raport;
            else exit;
        end if;
    end loop;
end;