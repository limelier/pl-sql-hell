create or replace type rectangle as object
(
    width  number,
    height number,
    diagonal number,
    member function get_area return number,
    member function get_perimeter return number,
    map member function get_diagonal return number,
    not final member procedure print_name,
    constructor function rectangle(width number, height number) return self as result
) not final;

create or replace type body rectangle as
    member function get_area return number as
        begin
            return width * height;
        end;
    member function get_perimeter return number as
        begin
            return 2 * (width + height);
        end;
    map member function get_diagonal return number as
        begin
            return diagonal;
        end;
    not final member procedure print_name as
        begin
            dbms_output.put_line('rectangle');
        end;
    constructor function rectangle(width number, height number) return self as result as
        begin
            self.width := width;
            self.height := height;
            self.diagonal := sqrt(width ** 2 + height ** 2);
            return;
        end;
end;

create or replace type square under rectangle
(
    overriding member procedure print_name,
    constructor function square(side number) return self as result
);

create or replace type body square as
    overriding member procedure print_name as
        begin
            dbms_output.put_line('square');
        end;
    constructor function square(side number) return self as result as
        begin
            self.height := side;
            self.width := side;
            self.diagonal := sqrt(2) * side;
            return;
        end;
end;

declare
    rect rectangle;
    sqre square;
begin
    rect := rectangle(3, 5);
    rect.print_name();
    sqre := square(4);
    sqre.print_name();
    if (rect < sqre)
        then dbms_output.put_line(rect.get_diagonal() || '<' || sqre.get_diagonal());
        else dbms_output.put_line(rect.get_diagonal() || '>=' || sqre.get_diagonal());
    end if;
end;
