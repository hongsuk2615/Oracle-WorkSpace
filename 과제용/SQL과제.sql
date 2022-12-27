--1
DECLARE
    E EMPLOYEE%ROWTYPE;
    Y_SALARY NUMBER;
BEGIN
    SELECT *
      INTO E
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
      
      Y_SALARY := E.SALARY*(1+NVL(E.BONUS,0))*12;   
      
      DBMS_OUTPUT.PUT_LINE('사번 : ' || E.EMP_ID);
      DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
      DBMS_OUTPUT.PUT_LINE('연봉 : ' || Y_SALARY);      
END;
/
--2
-- FOR LOOP

DECLARE 
    I NUMBER := 2;
    J NUMBER;
BEGIN
    LOOP
        J := 1;
        DBMS_OUTPUT.PUT_LINE('=========== '|| I ||' 단 ===========' );
        LOOP
            DBMS_OUTPUT.PUT_LINE(I ||' x ' || J || ' = ' || I*J);
            J := J + 1;
            EXIT WHEN J > 9;
        END LOOP;
        I := I + 2;
        EXIT WHEN I >9;
    END LOOP;
END;
/
-- WHILE LOOP
DECLARE 
    I NUMBER := 2;
    J NUMBER;
BEGIN
    WHILE I<10
    LOOP
        J := 1;
        DBMS_OUTPUT.PUT_LINE('=========== '|| I ||' 단 ===========' );
        WHILE(J < 10)
        LOOP
            DBMS_OUTPUT.PUT_LINE(I ||' x ' || J || ' = ' || I*J);
            J := J + 1;
        END LOOP;
        I := I + 2;
    END LOOP;
END;
/






--2