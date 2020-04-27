drop type elev force;
/
create or replace type elev as object
(
    id               varchar2(15),
    nume             varchar2(30),
    prenume          varchar2(30),
    clasa            varchar2(20),
    materie          varchar2(40),
    nota_teza        number(8, 2),
    --presupunem ca elevul este notat de 4 ori in decursul unui semestru pentru activitatea din timpul orelor
    nota1_activitate int,
    nota2_activitate int,
    nota3_activitate int,
    nota4_activitate int,
    constructor function elev(
        nume varchar2,
        prenume varchar2) return self as result,
    member
    function CalculMedieMaterie return varchar2,
    member
    procedure setnote(v_nota_teza int,v_nota1_activitate int,v_nota2_activitate int,v_nota3_activitate int,v_nota4_activitate int),
    map
    member
    function f_compara_note_teza return number
);
/
create or replace type body elev
is
    constructor function elev(
        nume varchar2,
        prenume varchar2) return self as result
        is
        begin
            self.id := id;
            self.nume := nume;
            self.prenume := prenume;
            self.clasa := clasa;
            self.materie := materie;
            return;
        end;

    member function CalculMedieMaterie
        return varchar2
        is
        begin
            return (self.nota_teza * 0.5 + self.nota1_activitate * 0.10 + self.nota2_activitate * 0.10 +
                    self.nota3_activitate * 0.15 + self.nota4_activitate * 0.15);
        end calculmediematerie;

    member procedure setnote(v_nota_teza int,v_nota1_activitate int,v_nota2_activitate int,v_nota3_activitate int,v_nota4_activitate int)
        is
        begin
            self.nota_teza := v_nota_teza;
            self.nota1_activitate := v_nota1_activitate;
            self.nota2_activitate := v_nota2_activitate;
            self.nota3_activitate := v_nota3_activitate;
            self.nota4_activitate := v_nota4_activitate;
        end setnote;

    map member function f_compara_note_teza
        return number
        is
        begin
            return nota_teza;
        end f_compara_note_teza;

end;
/
--apelul
declare
    obj_elev1 elev;
    obj_elev2 elev;
begin
    obj_elev1 := new elev(1,'Borcea','Cristian','XII_A','Matematica',5,4,8,7,10);
    obj_elev2 := new elev(2,'Becali','Gigi','XII_A','Matematica',6,3,5,7,8);
    if obj_elev1.nota_teza > obj_elev1.nota_teza then
        dbms_output.PUT_LINE('Elevul ' || obj_elev1.nume || ' are nota la teza mai mare.');
    else
        dbms_output.PUT_LINE('Elevul ' || obj_elev2.nume || ' are nota la teza mai mare.');
    end if;
    dbms_output.put_line(obj_elev1.nume || ' ' || obj_elev1.prenume || ' are media generala ' ||
                         trunc(obj_elev1.calculmediematerie, 2));
    dbms_output.put_line(obj_elev2.nume || ' ' || obj_elev2.prenume || ' are media generala ' ||
                         trunc(obj_elev2.calculmediematerie, 2));
--modificam nota la teza pentru elevul cu id-ul 1 de la 5 la 7
    obj_elev1.SetNote(7, 4, 8, 7, 10);
    dbms_output.put_line(obj_elev1.nume || ' ' || obj_elev1.prenume || ' are media generala dupa modificarea
    notei de la teza  ' || trunc(obj_elev1.calculmediematerie, 2));
end;


--SUPRASCRIEREA unei metode (am ales sa suprascriu metoda CalculMedieMaterie)
drop type elev force;
/
create or replace type elev as object
(
    id               varchar2(15),
    nume             varchar2(30),
    prenume          varchar2(30),
    clasa            varchar2(20),
    materie          varchar2(40),
    nota_teza        number(8, 2),
    nota1_activitate int,
    nota2_activitate int,
    nota3_activitate int,
    nota4_activitate int,
    constructor function elev(
        nume varchar2,
        prenume varchar2) return self as result,
    member
    function CalculMedieMaterie return varchar2,
    member
    procedure setnote(v_nota_teza int,v_nota1_activitate int,v_nota2_activitate int,v_nota3_activitate int,v_nota4_activitate int),
    map
    member
    function f_compara_nota_teza return number
) not final;
/
--se creeaza o subclasa a clasei Elev care are în plus o proprietate 'bonus_activitate' si care suprascrie metoda (functia) calcularii mediei
drop type elev_constiincios force;
/
create or replace type elev_constiincios under elev
(
    bonus_activitate number(2, 1),
    overriding
    member
    function CalculMedieMaterie return varchar2
);
/
create or replace type body elev_constiincios
is
    overriding
    member function CalculMedieMaterie return varchar2
        is
        begin
            return (self.nota_teza * 0.5 + self.nota1_activitate * 0.10 + self.nota2_activitate * 0.10 +
                    self.nota3_activitate * 0.15 + self.nota4_activitate * 0.15 + self.bonus_activitate);
        end calculmediematerie;
end;
/
declare
    v_elev_constiincios elev_constiincios;
begin
    v_elev_constiincios := Elev_Constiincios(2, 'Becali', 'Gigi', 'XII_A', 'Matematica', 6, 3, 5, 7, 8, 0.5);
    dbms_output.put_line(v_elev_constiincios.nume);
    dbms_output.put_line(v_elev_constiincios.prenume);
    dbms_output.put_line(v_elev_constiincios.calculmediematerie);
end;


--SUPRAINCARCAREA
drop type elev force;
/
create or replace type elev as object
(
    id               varchar2(15),
    nume             varchar2(30),
    prenume          varchar2(30),
    clasa            varchar2(20),
    materie          varchar2(40),
    nota_teza        number(8, 2),
    nota1_activitate int,
    nota2_activitate int,
    nota3_activitate int,
    nota4_activitate int,
    constructor function elev(
        nume varchar2,
        prenume varchar2) return self as result,
    --supraincarcarea o aratam pentru metoda CalculMedieMaterie de la primul punct (varianta originala, nu cea suprascrisa !)
    member
    function CalculMedieMaterie return varchar2,
    member
    function CalculMedieMaterie(v_id number) return varchar2,
    member
    procedure setnote(v_nota_teza int,v_nota1_activitate int,v_nota2_activitate int,v_nota3_activitate int,v_nota4_activitate int),
    map
    member
    function f_compara_note_teza return number
);
/
create or replace type body elev
is
    constructor function elev(
        nume varchar2,
        prenume varchar2) return self as result
        is
        begin
            self.id := id;
            self.nume := nume;
            self.prenume := prenume;
            self.clasa := clasa;
            self.materie := materie;
            return;
        end;

    member function CalculMedieMaterie
        return varchar2
        is
        begin
            return (self.nota_teza * 0.5 + self.nota1_activitate * 0.10 + self.nota2_activitate * 0.10 +
                    self.nota3_activitate * 0.15 + self.nota4_activitate * 0.15);
        end calculmediematerie;

    member function CalculMedieMaterie(v_id number)
        return varchar2
        is
        begin
            return (self.nota_teza * 0.5 + self.nota1_activitate * 0.10 + self.nota2_activitate * 0.10 +
                    self.nota3_activitate * 0.15 + self.nota4_activitate * 0.15);
        end calculmediematerie;

    member procedure setnote(v_nota_teza int,v_nota1_activitate int,v_nota2_activitate int,v_nota3_activitate int,v_nota4_activitate int)
        is
        begin
            self.nota_teza := v_nota_teza;
            self.nota1_activitate := v_nota1_activitate;
            self.nota2_activitate := v_nota2_activitate;
            self.nota3_activitate := v_nota3_activitate;
            self.nota4_activitate := v_nota4_activitate;
        end setnote;

    map member function f_compara_note_teza
        return number
        is
        begin
            return nota_teza;
        end f_compara_note_teza;

end;
/
declare
    obj_elev1 elev;
    obj_elev2 elev;
begin
    obj_elev1 := new elev(1,'Borcea','Cristian','XII_A','Matematica',5,4,8,7,10);
    obj_elev2 := new elev(2,'Becali','Gigi','XII_A','Matematica',6,3,5,7,8);
    if obj_elev1.nota_teza > obj_elev1.nota_teza then
        dbms_output.PUT_LINE('Elevul ' || obj_elev1.nume || ' are nota la teza mai mare.');
    else
        dbms_output.PUT_LINE('Elevul ' || obj_elev2.nume || ' are nota la teza mai mare.');
    end if;
    dbms_output.put_line(obj_elev1.nume || ' ' || obj_elev1.prenume || ' are media generala ' ||
                         trunc(obj_elev1.calculmediematerie, 2));
    dbms_output.put_line(obj_elev2.nume || ' ' || obj_elev2.prenume || ' are media generala ' ||
                         trunc(obj_elev2.calculmediematerie, 2));
--modificam nota la teza pentru elevul cu id-ul 1 de la 5 la 7
    obj_elev1.SetNote(7, 4, 8, 7, 10);
    --aici se remarca ca am folosit supraincarcarea metodei CalculMedieMaterie, pe care am apelat-o cu un parametru de intrare (id-ul elevului)
    dbms_output.put_line(obj_elev1.nume || ' ' || obj_elev1.prenume || ' are media generala dupa modificarea
    notei de la teza  ' || trunc(obj_elev1.CalculMedieMaterie(1), 2));
end;