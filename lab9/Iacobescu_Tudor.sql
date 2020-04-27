-- imported from wiki
create or replace function getType(v_rec_tab dbms_sql.desc_tab, v_nr_col int) return varchar2 as
    v_tip_coloana varchar2(200);
    v_precizie    varchar2(40);
begin
    case (v_rec_tab(v_nr_col).col_type)
        when 1 then v_tip_coloana := 'VARCHAR2'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        when 2 then v_tip_coloana := 'NUMBER';
                    v_precizie :=
                                '(' || v_rec_tab(v_nr_col).col_precision || ',' || v_rec_tab(v_nr_col).col_scale || ')';
        when 12 then v_tip_coloana := 'DATE'; v_precizie := '';
        when 96 then v_tip_coloana := 'CHAR'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        when 112 then v_tip_coloana := 'CLOB'; v_precizie := '';
        when 113 then v_tip_coloana := 'BLOB'; v_precizie := '';
        when 109 then v_tip_coloana := 'XMLTYPE'; v_precizie := '';
        when 101 then v_tip_coloana := 'BINARY_DOUBLE'; v_precizie := '';
        when 100 then v_tip_coloana := 'BINARY_FLOAT'; v_precizie := '';
        when 8 then v_tip_coloana := 'LONG'; v_precizie := '';
        when 180 then v_tip_coloana := 'TIMESTAMP'; v_precizie := '(' || v_rec_tab(v_nr_col).col_scale || ')';
        when 181 then v_tip_coloana := 'TIMESTAMP' || '(' || v_rec_tab(v_nr_col).col_scale || ') ' || 'WITH TIME ZONE';
                      v_precizie := '';
        when 231
            then v_tip_coloana := 'TIMESTAMP' || '(' || v_rec_tab(v_nr_col).col_scale || ') ' || 'WITH LOCAL TIME ZONE';
                 v_precizie := '';
        when 114 then v_tip_coloana := 'BFILE'; v_precizie := '';
        when 23 then v_tip_coloana := 'RAW'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        when 11 then v_tip_coloana := 'ROWID'; v_precizie := '';
        when 109 then v_tip_coloana := 'URITYPE'; v_precizie := '';
        end case;
    return v_tip_coloana || v_precizie;
end;
/
-- /imported


create or replace procedure catalog_materie(id_materie in number)
as
    c1               integer;
    c2               integer;
    ok               integer;
    nume_materie     cursuri.titlu_curs%type;
    nume_tabel       cursuri.titlu_curs%type;
    num_ap_tab       number;
    total_col        number;
    rec_tab          dbms_sql.desc_tab;
    nr_col           number;
    nume_valoare     varchar2(30);
    nume_data_notare varchar2(30);
    nume_nume        varchar2(30);
    nume_prenume     varchar2(30);
    nume_nr_matricol varchar2(30);
    tip_valoare      varchar2(30);
    tip_data_notare  varchar2(30);
    tip_nume         varchar2(30);
    tip_prenume      varchar2(30);
    tip_nr_matricol  varchar2(30);
    val_valoare      note.valoare%type;
    val_data_notare  note.data_notare%type;
    val_nume         studenti.nume%type;
    val_prenume      studenti.prenume%type;
    val_nr_matricol  studenti.nr_matricol%type;
begin
    -- AFLARE NUME MATERIE
    c1 := dbms_sql.open_cursor();
    dbms_sql.parse(c1, 'select titlu_curs from cursuri where id = :x', dbms_sql.native);
    dbms_sql.bind_variable(c1, ':x', id_materie);
    dbms_sql.define_column(c1, 1, nume_materie, 52);
    ok := dbms_sql.execute(c1);
    ok := dbms_sql.fetch_rows(c1);
    dbms_sql.column_value(c1, 1, nume_materie);
    dbms_sql.close_cursor(c1);

    -- MATERIA NU EXISTA -> CANCEL
    if nume_materie is null
    then
        return;
    end if;

    -- CONCATENEAZA CUVINTE
    nume_tabel := regexp_replace(nume_materie, '\s');
    dbms_output.put_line('Numele tabelului va fi ' || nume_tabel);

    -- STERGERE TABELA, IN CAZ DE EXISTENTA
    c1 := dbms_sql.open_cursor();
    dbms_sql.parse(c1, 'select count(*) from tab where tname = :x', dbms_sql.native);
    dbms_sql.bind_variable(c1, ':x', upper(nume_tabel));
    dbms_sql.define_column(c1, 1, num_ap_tab);
    ok := dbms_sql.execute(c1);
    ok := dbms_sql.fetch_rows(c1);
    dbms_sql.column_value(c1, 1, num_ap_tab);
    dbms_sql.close_cursor(c1);

    if (num_ap_tab > 0)
    then
        dbms_output.put_line('Tabelul exista deja, stergem...');
        c1 := dbms_sql.open_cursor();
        dbms_sql.parse(c1, 'drop table ' || nume_tabel, dbms_sql.native);
        ok := dbms_sql.execute(c1);
        dbms_sql.close_cursor(c1);
        dbms_output.put_line('Sters!');
    end if;

    -- AFLARE TIPURI DE DATE
    c1 := dbms_sql.open_cursor();
    dbms_sql.parse(c1, 'select valoare, data_notare, nume, prenume, nr_matricol ' ||
                       'from studenti natural join note', dbms_sql.native);
    ok := dbms_sql.execute(c1);
    dbms_sql.describe_columns(c1, total_col, rec_tab);
    nr_col := rec_tab.first;
    nume_valoare := rec_tab(nr_col).col_name;
    tip_valoare := getType(rec_tab, nr_col);
    nr_col := rec_tab.next(nr_col);
    nume_data_notare := rec_tab(nr_col).col_name;
    tip_data_notare := getType(rec_tab, nr_col);
    nr_col := rec_tab.next(nr_col);
    nume_nume := rec_tab(nr_col).col_name;
    tip_nume := getType(rec_tab, nr_col);
    nr_col := rec_tab.next(nr_col);
    nume_prenume := rec_tab(nr_col).col_name;
    tip_prenume := getType(rec_tab, nr_col);
    nr_col := rec_tab.next(nr_col);
    nume_nr_matricol := rec_tab(nr_col).col_name;
    tip_nr_matricol := getType(rec_tab, nr_col);
    dbms_sql.close_cursor(c1);

    -- CREARE TABELA
    dbms_output.put_line('Cream tabelul.');
    c1 := dbms_sql.open_cursor();
    dbms_sql.parse(c1,
                   'create table ' || nume_tabel || ' (' ||
                   nume_valoare || ' ' || tip_valoare || ', ' ||
                   nume_data_notare || ' ' || tip_data_notare || ', ' ||
                   nume_nume || ' ' || tip_nume || ', ' ||
                   nume_prenume || ' ' || tip_prenume || ', ' ||
                   nume_nr_matricol || ' ' || tip_nr_matricol ||
                   ')',
                   dbms_sql.native);
    ok := dbms_sql.execute(c1);
    dbms_sql.close_cursor(c1);

    -- INSERARE DATE
    -- o sa presupun ca nu trebuie sa folosim aici "create table x as (select y from z)", deci...
    dbms_output.put_line('Copiem datele.');
    c1 := dbms_sql.open_cursor();
    dbms_sql.parse(c1, 'select valoare, data_notare, nume, prenume, nr_matricol ' ||
                       'from studenti join note on studenti.id = note.id_student ' ||
                       'where id_curs = ' || id_materie, dbms_sql.native);
    dbms_sql.define_column(c1, 1, val_valoare);
    dbms_sql.define_column(c1, 2, val_data_notare);
    dbms_sql.define_column(c1, 3, val_nume, 15);
    dbms_sql.define_column(c1, 4, val_prenume, 30);
    dbms_sql.define_column(c1, 5, val_nr_matricol, 6);
    ok := dbms_sql.execute(c1);

    c2 := dbms_sql.open_cursor();
    dbms_sql.parse(c2, 'insert into ' || nume_tabel || ' values (' ||
                       ':val_valoare, ' ||
                       ':val_data_notare, ' ||
                       ':val_nume, ' ||
                       ':val_prenume, ' ||
                       ':val_nr_matricol)', dbms_sql.native);

    loop
        if dbms_sql.fetch_rows(c1) > 0 then

            dbms_sql.column_value(c1, 1, val_valoare);
            dbms_sql.column_value(c1, 2, val_data_notare);
            dbms_sql.column_value(c1, 3, val_nume);
            dbms_sql.column_value(c1, 4, val_prenume);
            dbms_sql.column_value(c1, 5, val_nr_matricol);

            dbms_sql.bind_variable(c2, ':val_valoare', val_valoare);
            dbms_sql.bind_variable(c2, ':val_data_notare', val_data_notare);
            dbms_sql.bind_variable(c2, ':val_nume', val_nume);
            dbms_sql.bind_variable(c2, ':val_prenume', val_prenume);
            dbms_sql.bind_variable(c2, ':val_nr_matricol', val_nr_matricol);

            ok := dbms_sql.execute(c2);
        else
            exit;
        end if;
    end loop;

    commit;
    dbms_sql.close_cursor(c1);
    dbms_sql.close_cursor(c2);

    dbms_output.put_line('Gata!');
exception
    when others then
        if dbms_sql.is_open(c1) then
            dbms_sql.close_cursor(c1);
        end if;
        if dbms_sql.is_open(c2) then
            dbms_sql.close_cursor(c2);
        end if;
end;


-- TEST
begin
    catalog_materie(10); -- nu multe cursuri au nume care chiar pot fi transformate in nume de tabel,
    -- dar "bazededate" merge
end;

select * from bazededate;
