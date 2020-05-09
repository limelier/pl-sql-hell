create or replace directory mydir as '/data/student';

declare
    v_fisier utl_file.file_type;
begin
    v_fisier := utl_file.fopen('MYDIR', 'myfile.txt', 'W');
    utl_file.putf(v_fisier, 'abcdefg');
    utl_file.fclose(v_fisier);
end;

set serveroutput on;
declare
    v_fisier utl_file.file_type;
    v_sir    varchar2(50);
begin
    v_fisier := utl_file.fopen('MYDIR', 'myfile.txt', 'R');
    utl_file.get_line(v_fisier, v_sir);
    dbms_output.put_line(v_sir);
    utl_file.fclose(v_fisier);
end;