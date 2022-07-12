SET SERVEROUTPUT ON;

-- PLSQL delete, SQL%ROWCOUNT 
DECLARE
    v_deptno NUMBER := 30;
    v_rows_deleted VARCHAR2(100);
BEGIN
    DELETE FROM employees
    WHERE department_id = v_deptno;
    v_rows_deleted := SQL%ROWCOUNT || ' rows deleted';
    DBMS_OUTPUT.PUT_LINE(v_rows_deleted);
END;
/

-- SELECT & JOIN
DECLARE
   v_employee_id NUMBER :=&v_employee_id;
   v_last_name employees.last_name%TYPE;
   v_deptname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_name
    INTO v_employee_id, v_last_name, v_deptname
    FROM employees JOIN departments
        USING (department_id)
    WHERE employee_id = v_employee_id;
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id ||' Employee Name: ' || v_last_name || ' Department name:' || v_deptname);
END;
/

-- Not using JOIN
DECLARE
    v_employee_id NUMBER :=&v_employee_id;
    v_last_name employees.last_name%TYPE;
    v_dept_id employees.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    -- SELECT FROM EMPLOYEES TABLE
    SELECT employee_id, last_name, department_id
    INTO v_employee_id, v_last_name, v_dept_id
    FROM employees
    WHERE employee_id = v_employee_id;
    
    -- SELECT FROM DEPARTMENTS TABLE
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_dept_id;

    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id ||' Employee Name: ' || v_last_name || ' Department name:' || v_deptname);
END;
/

-- TO_CHAR Function, Calculation 
DECLARE
    v_employee_id NUMBER :=&v_employee_id;
    v_last_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_commission_pct employees.commission_pct%TYPE;
    v_annual_sal NUMBER;
BEGIN
    SELECT last_name, salary, commission_pct
    INTO v_last_name, v_sal, v_commission_pct
    FROM employees
    WHERE employee_id = v_employee_id;
    v_annual_sal := v_sal * 12 + (nvl(v_sal, 0) * nvl(v_commission_pct, 0) * 12);
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Employee Salary:' || TO_CHAR(v_sal, '$999,999'));
    DBMS_OUTPUT.PUT_LINE('Employee Annual Salary:' || TO_CHAR(v_annual_sal, '$999,999'));
END;
/