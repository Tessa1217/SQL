SET SERVEROUTPUT ON;

DECLARE
    v_ename employees.last_name%TYPE;
    v_message VARCHAR2(30) := 'Hello, ';
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    -- SEQUENCE는 안 들어가짐
    WHERE employee_id = 114;
    DBMS_OUTPUT.PUT_LINE(v_message || v_ename);
END;
/

DECLARE 
    v_weight NUMBER(3) := 600;
    v_message VARCHAR2(255) := 'Product 10012';
    v_new_locn VARCHAR2(50) := 'Africa';
BEGIN
    DECLARE
        v_weight NUMBER(7, 2) := 50000;
        v_message VARCHAR2(255) := 'Product 11001';
        v_new_locn VARCHAR2(50) := 'Europe';
    BEGIN
        -- 50001
        v_weight := v_weight + 1;
        -- Product 11001 is in stock
        v_message := v_message || ' is in stock';
        -- WesternEurope
        v_new_locn := 'Western' || v_new_locn;
        DBMS_OUTPUT.PUT_LINE(v_message || ' ' ||  v_weight || ' ' || v_new_locn);
    END;
        -- 601
        v_weight := v_weight + 1;
        -- Product 10012 is in stock
        v_message := v_message || ' is in stock';
        -- Western Africa
        v_new_locn := 'Western' || ' ' || v_new_locn;
        DBMS_OUTPUT.PUT_LINE(v_message || ' ' || v_weight || ' ' || v_new_locn);
END;
/

