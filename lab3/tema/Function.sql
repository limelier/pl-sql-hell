create or replace function get_recommended_friends(sid STUDENTI.ID%TYPE)
    return VARCHAR2
    is
    json_string VARCHAR2(10000) := '{"friends": [';
begin
    for recom in (
        select *
        from (
                 select id, nume, prenume, count(friend) as count
                 from (
                          select s.ID as id, s.NUME as nume, s.PRENUME as prenume, p2.ID_STUDENT1 as friend
                          from prieteni p1
                                   join prieteni p2 on p1.ID_STUDENT2 = p2.ID_STUDENT1
                                   join studenti s on p2.ID_STUDENT2 = s.ID
                          where p1.ID_STUDENT1 = sid
                      )
                 group by id, nume, prenume
                 order by count(friend) desc
             )
        where rownum <= 5
        )
        loop
            json_string := json_string || '{';
            json_string := json_string || '"id": ' || recom.id || ', ';
            json_string := json_string || '"nume": "' || recom.nume || '", ';
            json_string := json_string || '"prenume": "' || recom.prenume || '", ';
            json_string := json_string || '"count": ' || recom.count;
            json_string := json_string || '}, ';
        end loop;
    json_string := json_string || ']}';

    DBMS_OUTPUT.PUT_LINE(json_string);
    return json_string;
end;

