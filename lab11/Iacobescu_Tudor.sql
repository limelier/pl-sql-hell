declare
    v_table_entries    number;
    v_is_nested        number;
    v_view_name        varchar2(100);
    v_lines_of_code    number;
    v_is_deterministic varchar2(100);
    v_argc             number;
begin
    dbms_output.put_line('User tables:');
    for tab in (select * from user_tables)
        loop
            dbms_output.put_line(tab.table_name || ':');

            --             table_entries := tab.num_rows;
            execute immediate 'select count(*) from ' || tab.table_name
                into v_table_entries;
            dbms_output.put_line('- ' || v_table_entries || ' entries');

            dbms_output.put_line('- columns:');
            for col in (select * from user_tab_cols where table_name = tab.table_name)
                loop
                    dbms_output.put_line('   - ' || col.column_name || ' of type ' || col.data_type);
                end loop;

            dbms_output.put_line('- constraints:');
            for cons in (select * from user_constraints where table_name = tab.table_name)
                loop
                    dbms_output.put_line('   - ' || cons.constraint_name || ' of type ' || cons.constraint_type ||
                                         ' on columns:');
                    for cons_column in (select * from user_cons_columns where constraint_name = cons.constraint_name)
                        loop
                            dbms_output.put_line('      - ' || cons_column.column_name);
                        end loop;
                end loop;

            dbms_output.put_line('- indexes:');
            for ind in (select index_name from user_indexes where table_name = tab.table_name)
                loop
                    dbms_output.put_line('   - ' || ind.index_name);
                end loop;

            select count(*) into v_is_nested from user_nested_tables where table_name = tab.table_name;
            if (v_is_nested > 0) then
                dbms_output.put_line('- table is a nested table');
            end if;
        end loop;


    dbms_output.put_line('User views:');
    for "view" in (select * from user_views)
        loop
            v_view_name := "view".view_name;
            dbms_output.put_line(v_view_name || ':');
            for col in (select * from user_tab_cols where table_name = v_view_name)
                loop
                    dbms_output.put_line('   - ' || col.column_name || ' of type ' || col.data_type);
                end loop;

        end loop;


    dbms_output.put_line('User indexes:');
    for ind in (select * from user_indexes)
        loop
            dbms_output.put_line(ind.index_name || ' on table ' || ind.table_name || ' on columns:');
            for col in (select * from user_ind_columns where index_name = ind.index_name)
                loop
                    dbms_output.put_line('- ' || col.column_name);
                end loop;
        end loop;


    dbms_output.put_line('User types:');
    for type in (select * from user_types)
        loop
            select count(*) into v_lines_of_code from user_source where name = type.type_name;
            dbms_output.put_line('- lines of code: ' || v_lines_of_code);
            dbms_output.put_line(type.type_name || ' with typecode ' || type.typecode);
            if (type.attributes > 0) then
                dbms_output.put_line('- ' || type.attributes || ' attributes:');
                for attr in (select * from user_type_attrs where type_name = type.type_name)
                    loop
                        dbms_output.put_line('   - ' || attr.attr_name || ' of type ' || attr.attr_type_name);
                    end loop;
            end if;

            if (type.methods > 0) then
                dbms_output.put_line('- ' || type.methods || ' methods:');
                for met in (select * from user_type_methods where type_name = type.type_name)
                    loop
                        dbms_output.put_line('   - ' || met.method_name || ' of type ' || met.method_type);
                    end loop;
            end if;
        end loop;


    dbms_output.put_line('User packages:');
    for pack in (select * from user_objects where object_type = 'PACKAGE')
        loop
            dbms_output.put_line(pack.object_name || ':');
            select count(*) into v_lines_of_code from user_source where name = pack.object_name;
            dbms_output.put_line('   with ' || v_lines_of_code || ' lines of code and the following functions/procedures:');
            for q in (select * from user_procedures where object_name = pack.object_name)
                loop
                    dbms_output.put_line('- ' || q.procedure_name);
                end loop;

        end loop;

    dbms_output.put_line('User procedures :');
    for proc in (select * from user_objects where object_type = 'PROCEDURE')
        loop
            dbms_output.put_line(proc.object_name || ':');
            select count(*) into v_lines_of_code from user_source where name = proc.object_name;
            dbms_output.put_line('- lines of code: ' || v_lines_of_code);
            select deterministic into v_is_deterministic from user_procedures where object_name = proc.object_name;
            dbms_output.put_line('- deterministic? ' || v_is_deterministic);
        end loop;

    dbms_output.put_line('User functions:');
    for func in (select * from user_objects where object_type = 'FUNCTION')
        loop
            dbms_output.put_line(func.object_name || ':');
            select count(*) into v_lines_of_code from user_source where name = func.object_name;
            dbms_output.put_line('- lines of code: ' || v_lines_of_code);
            select deterministic into v_is_deterministic from user_procedures where object_name = func.object_name;
            dbms_output.put_line('- deterministic? ' || v_is_deterministic);

            select count(*) into v_argc from user_arguments where object_name = func.object_name and position > 0;
            if (v_argc > 0) then
                dbms_output.put_line('- args:');
                for arg in (select * from user_arguments where object_name = func.object_name and position > 0)
                    loop
                        dbms_output.put_line('   - ' || arg.argument_name || ' of type ' || arg.data_type);
                    end loop;
            end if;
        end loop;
end;