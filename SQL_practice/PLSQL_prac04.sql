CREATE OR REPLACE PROCEDURE ssn_format
(v_ssn IN OUT VARCHAR2)
IS
BEGIN
    -- SUBSTR(v_ssn, 1, 6) || '-' || RPAD(SUBSTR(v_ssn, 7, 1), 7, '*')
    v_ssn := SUBSTR(v_ssn, 1, 6) || '-' || SUBSTR(RPAD(SUBSTR(v_ssn, 1, 6), LENGTH(v_ssn), '*'), 7); 
    DBMS_OUTPUT.PUT_LINE(v_ssn);
END;
/

DECLARE
    v_ssn VARCHAR2(100) :='9501011667777';
BEGIN
    ssn_format(v_ssn);
END;
/

CREATE OR REPLACE PROCEDURE test_pro
    (v_id IN employees.employee_id%TYPE)
    IS
    no_emp EXCEPTION;
BEGIN
    DELETE FROM employees
    WHERE employee_id = v_id;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE no_emp;
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_id || ' 사원 삭제가 완료되었습니다.');
    END IF;
EXCEPTION
    WHEN no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다.');
END;
/

EXECUTE TEST_PRO(99);

SELECT * FROM employees;

CREATE OR REPLACE PROCEDURE emp_name_form 
    (v_id employees.employee_id%TYPE, 
    v_name OUT employees.last_name%TYPE)
    IS
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE employee_id = v_id;
    v_name := SUBSTR(v_name, 1, 1)||SUBSTR(RPAD(SUBSTR(v_name, 1, 1), LENGTH(v_name), '*'), 2);
END;
/

VARIABLE g_name VARCHAR2;
EXECUTE emp_name_form(114, :g_name);
PRINT g_name;
