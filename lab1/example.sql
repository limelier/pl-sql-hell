-- DataGrip note: have to turn on serveroutput in DataGrip too
set serveroutput on; -- printing to screen doesn't work without this
DECLARE -- this block is where declarations go
    v_message VARCHAR2(50) := 'Hello, world!';
BEGIN -- this block is where code coes
    DBMS_OUTPUT.PUT_LINE('Message: ' || v_message); -- print to screen
END;

-- random value demo
set serveroutput on;
DECLARE
   a NUMBER := TRUNC(DBMS_RANDOM.VALUE(0,100)); -- eliminati atribuirea pentru a fi NULL;
BEGIN
   IF (a IS NOT NULL)
      THEN
         IF (a BETWEEN 20 AND 80)
              THEN DBMS_OUTPUT.PUT_LINE(a || ' este intre 20 si 80');
              ELSE DBMS_OUTPUT.PUT_LINE(a || ' NU este intre 20 si 80');
         END IF;
      ELSE DBMS_OUTPUT.PUT_LINE('Valoare nula');
   END IF;
END;

-- can declare using the type of something else; demo of "INTO"
DECLARE
   v_valoare_nota_maxima note.valoare%TYPE;
BEGIN
   SELECT MAX(valoare) INTO v_valoare_nota_maxima FROM note;
   DBMS_OUTPUT.PUT_LINE('Nota maxima: ' || v_valoare_nota_maxima);
END;

