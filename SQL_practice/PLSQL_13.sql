CREATE OR REPLACE FUNCTION get_sal
    -- 매개변수(Optional) => IN만 가능
    (v_id IN employees.employee_id%TYPE)
    -- RETURN TYPE
    RETURN NUMBER
    IS 
    v_sal employees.salary%TYPE;
BEGIN
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = v_id;
    RETURN v_sal;
END;
/


SELECT employee_id, last_name, salary
FROM employees
WHERE salary > get_sal(114);

VARIABLE g_salary NUMBER;
EXECUTE :g_salary := get_sal(114);
PRINT g_salary;

CREATE FUNCTION check_sal 
    RETURN BOOLEAN 
    IS
    v_dept_id employees.department_id%TYPE;
    v_empno employees.employee_id%TYPE;
    v_sal employees.salary%TYPE;
    v_avg_sal employees.salary%TYPE;
BEGIN
    v_empno := 205;
    SELECT salary, department_id
    INTO v_sal, v_dept_id
    FROM employees
    WHERE employee_id = v_empno;
    SELECT avg(salary) INTO v_avg_sal FROM employees WHERE department_id = v_dept_id;
    IF v_sal > v_avg_sal THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        RETURN NULL;
END;
/
DECLARE
    v_check BOOLEAN;
BEGIN
    v_check := check_sal();
    IF v_check THEN
        DBMS_OUTPUT.PUT_LINE('평균 월급보다 많이 받음');
    ELSIF v_check IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('해당하는 사원이 없음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('평균 월급보다 적게 받음');
    END IF;
END;
/
