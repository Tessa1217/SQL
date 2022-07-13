SET SERVEROUTPUT ON;

-- TABLE 
DECLARE
    TYPE emp_table_type IS TABLE OF employees.last_name%TYPE
        INDEX BY BINARY_INTEGER;
    emp_last_name emp_table_type;
BEGIN
    emp_last_name(1) := 'Kim';
    IF emp_last_name.EXISTS(1) THEN
        DBMS_OUTPUT.PUT_LINE(emp_last_name(1));
    END IF;
END;
/

-- TABLE, COUNT
DECLARE
    TYPE dept_table_type IS TABLE OF NUMBER
    INDEX BY BINARY_INTEGER;
    dept_table dept_table_type;
    v_total NUMBER;
BEGIN
    FOR v_counter IN 1..50 LOOP
        dept_table(v_counter) := v_counter;
        DBMS_OUTPUT.PUT_LINE('지금 들어간 숫자: ' || dept_table(v_counter));
    END LOOP;
    v_total := dept_table.COUNT;
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

-- TABLE, DELETE
-- DELETE(n) - n 인덱스 지움
-- DELETE(n, i) - n~i 사이의 인덱스 지움
-- DELETE - TABLE 전체 내용 다 지움 
DECLARE
    TYPE test_table_type IS TABLE OF VARCHAR2(10)
    INDEX BY BINARY_INTEGER;
    test_table test_table_type;
BEGIN
    test_table(1) := 'One';
    test_table(3) :='Three';
    test_table(-2) := 'Minus Two';
    test_table(0) := 'Zero';
    test_table(100) := 'Hundred';
    DBMS_OUTPUT.PUT_LINE(test_table.COUNT);
    DBMS_OUTPUT.PUT_LINE(test_table.FIRST);
    DBMS_OUTPUT.PUT_LINE(test_table(1));
    DBMS_OUTPUT.PUT_LINE(test_table(3));
    DBMS_OUTPUT.PUT_LINE(test_table(-2));
    DBMS_OUTPUT.PUT_LINE(test_table(0));
    DBMS_OUTPUT.PUT_LINE(test_table(100));
    DBMS_OUTPUT.PUT_LINE(test_table.LAST);
    DBMS_OUTPUT.PUT_LINE(test_table(test_table.LAST));
    test_table.DELETE(100);
    test_table.DELETE(1, 3);
    test_table.DELETE;
END;
/

-- TABLE, FIRST, LAST
DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
    emp_table emp_table_type;
    max_count NUMBER(3) := 104;
BEGIN
    FOR i IN 100..max_count LOOP
        SELECT * INTO emp_table(i) FROM employees
         WHERE employee_id = i;
    END LOOP;
    FOR i IN emp_table.FIRST..emp_table.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(emp_table(i).last_name);
    END LOOP;
END;
/