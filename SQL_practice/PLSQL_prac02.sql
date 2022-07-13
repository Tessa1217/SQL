/* 
1.
2000년도(포함) 이전에 입사한 사람은 test01, 이후에 입사한 사람은 test02에 인서트
*/

-- FOR LOOP
DECLARE
    CURSOR emp_cursor IS 
        SELECT employee_id, last_name, hire_date FROM employees ORDER BY 1;
BEGIN
    FOR emp_record IN emp_cursor
    LOOP
        IF TO_CHAR(emp_record.hire_date, 'YYYY') <= 2000 THEN
            INSERT INTO test01 VALUES emp_record;
        ELSE 
            INSERT INTO test02 VALUES emp_record;
        END IF;
    END LOOP;
END;
/

-- Subquery
BEGIN
    FOR emp_record IN (SELECT employee_id, last_name, hire_date FROM employees ORDER BY 1)
    LOOP
        IF TO_CHAR(emp_record.hire_date, 'YYYY') <= 2000 THEN
            INSERT INTO test01 VALUES emp_record;
        ELSE 
            INSERT INTO test02 VALUES emp_record;
        END IF;
    END LOOP;
END;
/

-- LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date FROM employees ORDER BY 1;
    emp_record emp_cursor%ROWTYPE;
BEGIN
    IF NOT emp_cursor%ISOPEN THEN
        OPEN emp_cursor;
    END IF;
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        IF TO_CHAR(emp_record.hire_date, 'YYYY') <= 2000 THEN
            INSERT INTO test01 VALUES emp_record;
        ELSE
            INSERT INTO test02 VALUES emp_record;
        END IF;
    END LOOP;
    CLOSE emp_cursor;
END;
/

-- CURSOR parameter
DECLARE
    CURSOR emp_cursor(v_deptno NUMBER, v_job VARCHAR2) IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = v_deptno
        AND job_id = v_job;
BEGIN
    FOR emp_record IN emp_cursor(&deptno, 'SA_REP') LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(emp_record.last_name);
    END LOOP;
END;
/

-- CURSOR FOR UPDATE, WHERE CURRENT OF 
SELECT SUM(salary)
FROM employees;

DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees
        -- 반드시 수정 전에 락 걸어줘야함
        FOR UPDATE OF salary NOWAIT;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        UPDATE employees
        SET salary = emp_record.salary * 1.1
        WHERE CURRENT OF emp_cursor;
    END LOOP;
END;
/

/* 
부서번호를 입력할 경우 해당하는 정보 출력
*/
-- FOR
DECLARE
    CURSOR emp_cursor(v_dept_id NUMBER) IS
        SELECT last_name, hire_date, department_name
        FROM employees JOIN departments
        USING (department_id)
        WHERE department_id = v_dept_id;
BEGIN
    FOR emp_record IN emp_cursor(&deptId) LOOP
            DBMS_OUTPUT.PUT_LINE('Employee Info: ' || emp_record.last_name || ' | ' || emp_record.hire_date || ' | ' || emp_record.department_name);
    END LOOP; 
END;
/

-- LOOP
DECLARE
    CURSOR emp_cursor(v_dept_id NUMBER) IS
        SELECT last_name, hire_date, department_name
        FROM employees JOIN departments
        USING (department_id)
        WHERE department_id = v_dept_id;
    emp_record emp_cursor%ROWTYPE;
BEGIN
    IF NOT emp_cursor%ISOPEN THEN
        OPEN emp_cursor(&deptId);
    END IF;
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee Info: ' || emp_record.last_name || ' | ' || emp_record.hire_date || ' | ' || emp_record.department_name);
    END LOOP;
    CLOSE emp_cursor;
END;
/

/* 
부서번호 입력하면 소속된 사원의 사원번호, 사원이름, 부서번호 출력 
*/
-- FOR
DECLARE
    CURSOR emp_cursor(v_dept_id NUMBER) IS
        SELECT employee_id, last_name, department_id
        FROM employees
        WHERE department_id = v_dept_id;
BEGIN
    FOR emp_record IN emp_cursor(&deptId) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee Info: ' || emp_record.last_name || ' | ' || emp_record.employee_id || ' | ' || emp_record.department_id);
    END LOOP;
END;
/

-- LOOP
DECLARE
    CURSOR emp_cursor(v_dept_id NUMBER) IS
        SELECT employee_id, last_name, department_id
        FROM employees
        WHERE department_id = v_dept_id;
    emp_record emp_cursor%ROWTYPE;
BEGIN
    IF NOT emp_cursor%ISOPEN THEN
        OPEN emp_cursor(&deptId);
    END IF;
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee Info: ' || emp_record.last_name || ' | ' || emp_record.employee_id || ' | ' || emp_record.department_id);
    END LOOP;
    CLOSE emp_cursor;
END;
/

/* 
부서 번호 입력할 경우 사원이름, 급여, 연봉 출력
*/
-- FOR
DECLARE
    CURSOR emp_cursor(v_dept_id NUMBER) IS
        SELECT last_name, salary, salary * 12 + (salary + NVL(commission_pct, 0) * 12) AS annual_salary
        FROM employees
        WHERE department_id = v_dept_id;
BEGIN   
    FOR emp_record IN emp_cursor(&deptId) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee Info: ' || emp_record.last_name || ' | ' || emp_record.salary || ' | ' || emp_record.annual_salary);
    END LOOP;
END;
/

-- LOOP
DECLARE
    CURSOR emp_cursor(v_dept_id NUMBER) IS
        SELECT last_name, TO_CHAR(salary, '$999,999') AS salary, TO_CHAR((salary * 12 + (salary + NVL(commission_pct, 0) * 12)), '$999,999') AS annual_salary
        FROM employees
        WHERE department_id = v_dept_id;
    emp_record emp_cursor%ROWTYPE;
BEGIN
    IF NOT emp_cursor%ISOPEN THEN
        OPEN emp_cursor(&deptId);
    END IF;
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee Info: ' || emp_record.last_name || ' | ' || emp_record.salary || ' | ' || emp_record.annual_salary);
    END LOOP;
    CLOSE emp_cursor;
END;
/

SELECT * FROM employees;