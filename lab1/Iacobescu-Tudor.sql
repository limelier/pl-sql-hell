-- to send to: alex_mihnea@yahoo.com
-- apx 50 min

set serveroutput on;

-- ex 1 (3p):
-- creati un bloc anonim care sa ia din baza de date, intr-o variabila (pe care o afisati), numele profesorului care are cele mai multe cursuri (primul in ordine alfabetica); afisati cate caractere are numele acestuia; de asemenea, afisati daca a pus vreodata o nota de 10

declare
    v_prof    PROFESORI.NUME%TYPE;
    v_id_prof PROFESORI.ID%TYPE;
    v_note    NUMBER;
begin
    select nume_prof, id_prof
    into v_prof, v_id_prof
    from (
             select p.nume as nume_prof, p.ID as id_prof, count(c.ID)
             from PROFESORI p
                      join DIDACTIC d on p.ID = d.ID_PROFESOR
                      join CURSURI c on d.ID_CURS = c.ID -- <!> NOT NEEDED, DEGRADES PERFORMANCE
             group by p.nume, p.ID
             order by count(c.ID) desc
         )
    where rownum = 1;
    DBMS_OUTPUT.PUT_LINE('Profesorul este ' || v_prof || '.');

    DBMS_OUTPUT.PUT_LINE('Are ' || length(v_prof) || ' caractere in nume.');

    select count(n.ID)
    into v_note
    from didactic d
             join CURSURI c on d.ID_CURS = c.ID
             join NOTE n on c.ID = n.ID_CURS
    where d.ID_PROFESOR = v_id_prof
      and n.VALOARE = 10;

    if (v_note > 0)
    then
        DBMS_OUTPUT.PUT_LINE('A pus ' || v_note || ' note de 10.');
    else
        DBMS_OUTPUT.PUT_LINE('Nu a pus nicio nota de 10.');
    end if;
end;

-- ex 2 (2p):
-- pentru o secventa de caractere introduse de la tastatura (declare p_name student.nume%TYPE = "GIGI") afisati numarul studentilor care au in componenta numelui acel sir de caractere; afisati un numar aleator reprezentand o pozitie din lista studentilor ce satisface conditia de mai sus, ordonata dupa id-ul studentului; daca nu exista nici unul, dati un mesaj corespunzator

declare
    v_string VARCHAR2(20);
    v_num    NUMBER;
    v_rand   NUMBER;
begin
    v_string := &i_string;

    select count(ID)
    into v_num
    from STUDENTI
    where NUME like '%' || v_string || '%';

    if (v_num > 0)
    then
        DBMS_OUTPUT.PUT_LINE(v_num || ' studenti care au in componenta numelui "' || v_string || '"');

        v_rand := round((DBMS_RANDOM.VALUE(1, v_num)));
        DBMS_OUTPUT.PUT_LINE('Indexul unuia dintre acestia: ' || v_rand);
    else
        DBMS_OUTPUT.PUT_LINE('Nu exista studenti care sa se potriveasca.');
    end if;
end;


