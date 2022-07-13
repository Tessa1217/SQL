-- CURSOR
DECLARE
    v_emp_id employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    CURSOR emp_cursor IS
        SELECT employee_id, last_name FROM employees;
BEGIN
    OPEN emp_cursor;
    -- 반복문 사용하여 다시 FETCH를 만나야 닫히지 않고 
    -- 반복적으로 커서 포인터 부분을 움직일 수 있음
    LOOP
    FETCH emp_cursor INTO v_emp_id, v_name;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee Id: ' || v_emp_id);
        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_name);
    END LOOP;
    CLOSE emp_cursor;
END;
/

-- USING RECORD
DECLARE
    CURSOR c_emp_cursor IS
        SELECT employee_id, last_name FROM employees;
    TYPE   emp_info_record_type IS RECORD (
        v_id employees.employee_id%TYPE,
        v_name employees.last_name%TYPE
    );
    emp_info_record emp_info_record_type;
BEGIN  
    -- 오픈 여부 확인
    IF NOT c_emp_cursor%ISOPEN THEN
        OPEN c_emp_cursor;
        DBMS_OUTPUT.PUT_LINE('===Cursor Open===');
    END IF;
    LOOP
    FETCH c_emp_cursor INTO emp_info_record;
        EXIT WHEN c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || emp_info_record.v_id);
        DBMS_OUTPUT.PUT_LINE('Last Name: ' || emp_info_record.v_name);
        -- POINTER 위치
        DBMS_OUTPUT.PUT_LINE(c_emp_cursor%ROWCOUNT);
    END LOOP;
    -- 커서 닫힘
    CLOSE c_emp_cursor;
    DBMS_OUTPUT.PUT_LINE('===Cursor Close===');
END;
/

-- CURSOR, CURSOR%ROWTYPE, %ROWCOUNT 
DECLARE
    CURSOR dept IS
        SELECT department_id, department_name FROM departments 
            ORDER BY department_id;
--    TYPE dept_info_type IS RECORD(
--        dept_id departments.department_id%TYPE,
--        dept_name departments.department_name%TYPE
--    );
--    dept_info dept_info_type;
    -- CURSOR를 이용한 ROWTYPE 사용
    dept_info dept%ROWTYPE;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM departments;
    IF NOT dept%ISOPEN THEN
        OPEN dept;
    END IF;
    LOOP
        FETCH dept INTO dept_info;
        EXIT WHEN dept%ROWCOUNT > v_count OR dept%NOTFOUND;
--        DBMS_OUTPUT.PUT_LINE('Department ID: ' || dept_info.dept_id);
--        DBMS_OUTPUT.PUT_LINE('Department Name: ' || dept_info.dept_name); 
        DBMS_OUTPUT.PUT_LINE('Department ID: ' || dept_info.department_id);
        DBMS_OUTPUT.PUT_LINE('Department Name: ' || dept_info.department_name);
    END LOOP;
    CLOSE dept;
END;
/

CREATE TABLE temp_list(
    empid NUMBER,
    empname VARCHAR2(100)
);

DECLARE 
    CURSOR emp_cursor IS
        SELECT employee_id, last_name FROM employees WHERE department_id = 20 ORDER BY 1;
    emp_record emp_cursor%ROWTYPE;
BEGIN
    IF NOT emp_cursor%ISOPEN THEN
        OPEN emp_cursor;
    END IF;
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        INSERT INTO temp_list (empid, empname) VALUES (emp_record.employee_id, emp_record.last_name);
    END LOOP;
    COMMIT;
    CLOSE emp_cursor;
END;
/

SELECT * FROM temp_list;

-- FOR LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name FROM employees ORDER BY 1;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(emp_record.last_name);
    END LOOP;
END;
/

-- CURSOR, JOIN
DECLARE 
    CURSOR emp_cursor IS
        SELECT employee_id, CONCAT(first_name, ' ') || last_name AS name, department_name 
        FROM employees JOIN departments
            USING (department_id)
            ORDER BY 1;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        IF emp_record.department_name = 'Administration' OR emp_record.department_name = 'Accounting' THEN
            DBMS_OUTPUT.PUT_LINE('===Employee Information===');
            DBMS_OUTPUT.PUT_LINE('ID: ' || emp_record.employee_id);
            DBMS_OUTPUT.PUT_LINE('Name: ' || emp_record.name);
            DBMS_OUTPUT.PUT_LINE('Department: ' || emp_record.department_name);
            DBMS_OUTPUT.PUT_LINE('=======================');
        END IF;
    END LOOP;
END;
/

