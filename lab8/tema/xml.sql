create or replace procedure export_catalog as
    cursor catalog is
        select nume, prenume, titlu_curs, valoare, data_notare
        from note
                 join studenti s on note.id_student = s.id
                 join cursuri c2 on note.id_curs = c2.id;
    v_file utl_file.file_type;
begin
    v_file := utl_file.fopen('MYDIR', 'catalog.xml', 'W');
    utl_file.put_line(v_file, '<catalog>');
    for entry in catalog
        loop
            utl_file.put_line(v_file, '<entry name="' ||
                                      entry.nume ||
                                      '" surname="' ||
                                      entry.prenume ||
                                      '" course="' ||
                                      entry.titlu_curs ||
                                      '" value="' ||
                                      entry.valoare ||
                                      '" date="' ||
                                      entry.data_notare ||
                                      '"/>');
        end loop;
    utl_file.put_line(v_file, '</catalog>');
    utl_file.fclose(v_file);
end;

begin
    export_catalog;
end;