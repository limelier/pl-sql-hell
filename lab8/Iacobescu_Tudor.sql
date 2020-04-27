create or replace procedure export_note(filename varchar2) as
    cursor note_data is
        select *
        from note;
    v_file utl_file.file_type;
begin
    v_file := utl_file.fopen('MYDIR', filename, 'W');
    for nota in note_data
        loop
            utl_file.put_line(v_file,
                              nota.id || ',' ||
                              nota.id_student || ',' ||
                              nota.id_curs || ',' ||
                              nota.valoare || ',' ||
                              nota.data_notare || ',' ||
                              nota.created_at || ',' ||
                              nota.updated_at
                );
        end loop;
    utl_file.fclose(v_file);

exception
    when others then
        utl_file.fclose(v_file);
        raise;
end;

create or replace procedure import_note(filename varchar2) as
    v_file          utl_file.file_type;
    v_line          varchar2(1024);
    v_search_pos    number;
    row_id          varchar2(50);
    row_id_student  varchar2(50);
    row_id_curs     varchar2(50);
    row_valoare     varchar2(50);
    row_data_notare varchar2(50);
    row_created_at  varchar2(50);
    row_updated_at  varchar2(50);
begin
    v_file := utl_file.fopen('MYDIR', filename, 'R');
    loop
        begin
            utl_file.get_line(v_file, v_line);
            v_search_pos := 1;

            row_id := regexp_substr(v_line, '[^,]+', v_search_pos);
            v_search_pos := v_search_pos + length(row_id) + 1;
            row_id_student := regexp_substr(v_line, '[^,]+', v_search_pos);
            v_search_pos := v_search_pos + length(row_id_student) + 1;
            row_id_curs := regexp_substr(v_line, '[^,]+', v_search_pos);
            v_search_pos := v_search_pos + length(row_id_curs) + 1;
            row_valoare := regexp_substr(v_line, '[^,]+', v_search_pos);
            v_search_pos := v_search_pos + length(row_valoare) + 1;
            row_data_notare := regexp_substr(v_line, '[^,]+', v_search_pos);
            v_search_pos := v_search_pos + length(row_data_notare) + 1;
            row_created_at := regexp_substr(v_line, '[^,]+', v_search_pos);
            v_search_pos := v_search_pos + length(row_created_at) + 1;
            row_updated_at := regexp_substr(v_line, '[^,]+', v_search_pos);

            insert into note
            values (to_number(row_id),
                    to_number(row_id_student),
                    to_number(row_id_curs),
                    to_number(row_valoare),
                    to_date(row_data_notare),
                    to_date(row_created_at),
                    to_date(row_updated_at));
        exception
            when no_data_found then
                utl_file.fclose(v_file);
                exit;
        end;
    end loop;
end;

begin
    export_note('note.csv');
    delete from note;
    import_note('note.csv');
end;

select count(*) from note;