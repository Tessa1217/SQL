/* 2. */
DECLARE
    v_deptname departments.department_name%TYPE;
    v_jobid employees.job_id%TYPE;
    v_salary employees.salary%TYPE;
    v_annual_sal employees.salary%TYPE;
BEGIN
    SELECT department_name, job_id, NVL(salary, 0), ((NVL(salary, 0) + (NVL(salary, 0) * NVL(commission_pct, 0))) * 12) as annual_salary
    INTO v_deptname, v_jobid, v_salary, v_annual_sal
    FROM employees JOIN departments
    ON employees.department_id = departments.department_id
    WHERE employee_id = &empid;
    DBMS_OUTPUT.PUT_LINE('부서이름: ' || v_deptname || ', 직업 아이디: ' || v_jobid || ', 급여: ' || v_salary || ', 연간 총수입: ' || v_annual_sal);
END;
/

/* 3 */
DECLARE
    v_hiredate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hiredate
    FROM employees
    WHERE employee_id = &empid;
    IF v_hiredate >= '1998/01/01' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/

/* 4 */

BEGIN
    FOR i in 1..9 LOOP
        IF MOD(i, 2) != 0 THEN
        DBMS_OUTPUT.PUT_LINE('===' || i || '단====');
        FOR j in 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || ' X ' || j || ' = ' || (i*j));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('==========');
        END IF;    
    END LOOP;
END;
/

/* 5 */

DECLARE
    CURSOR emp_cursor IS
        SELECT * FROM employees
        WHERE department_id = &deptid;
BEGIN
   FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('사번: ' || emp_record.employee_id || ', 이름: ' || emp_record.last_name || ', 급여: ' || emp_record.salary);
    END LOOP;
END;
/

/* 6.*/
CREATE OR REPLACE PROCEDURE update_sal
    (v_empid employees.employee_id%TYPE, 
    v_raise NUMBER)
    IS
    no_emp EXCEPTION;
BEGIN    
    UPDATE employees SET salary = salary * (1 + (v_raise/100))
    WHERE employee_id = v_empid;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('업데이트 완료');
    ELSIF SQL%NOTFOUND THEN
        RAISE no_emp;
    END IF;
EXCEPTION
    WHEN no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

EXECUTE update_sal(114, 10);

/* 7.*/
CREATE OR REPLACE PACKAGE ssn_calc
    IS
        PROCEDURE age_calc
            (v_ssn IN VARCHAR2);
        FUNCTION kor_age_calc
            (v_ssn IN VARCHAR2)
            RETURN NUMBER;
        FUNCTION sex_calc
            (v_ssn IN VARCHAR2)
            RETURN VARCHAR2;
END ssn_calc;
/

CREATE OR REPLACE PACKAGE BODY ssn_calc
    IS
    -- 만나이 계산기 (개월수 기준으로)
    PROCEDURE age_calc
        (v_ssn IN VARCHAR2)
        IS 
        v_age NUMBER;
        BEGIN
            v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(v_ssn, 1, 6), 'RRMMDD'))/12);
            DBMS_OUTPUT.PUT_LINE('나이: ' || v_age);
        END age_calc;
    -- 한국 나이 계산기
    FUNCTION kor_age_calc
        (v_ssn IN VARCHAR2)
        RETURN NUMBER
        IS 
        BEGIN
            IF SUBSTR(v_ssn, 7, 1) IN (1, 2) THEN
                RETURN ((100 + SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 3, 2)) - SUBSTR(v_ssn, 1, 2)) + 1;
            ELSIF SUBSTR(v_ssn, 7, 1) IN (3, 4) THEN
                RETURN (SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 3, 2) - SUBSTR(v_ssn, 1, 2)) + 1;
            END IF;
        END kor_age_calc;
    FUNCTION sex_calc
        (v_ssn IN VARCHAR2)
        RETURN VARCHAR2
        IS
        BEGIN
            IF MOD(SUBSTR(v_ssn, 7, 1), 2) != 0 THEN
                RETURN 'Male';
            ELSE
                RETURN 'Female';
            END IF;
        END sex_calc;
END ssn_calc;
/

EXECUTE ssn_calc.age_calc('9911021234567');
SELECT ssn_calc.kor_age_calc('9911021234567') FROM dual;
SELECT ssn_calc.sex_calc('9911021234567') FROM dual;

/* 8.*/
CREATE OR REPLACE FUNCTION emp_year
    (v_empid IN employees.employee_id%TYPE)
    RETURN NUMBER
    IS
    v_hiredate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hiredate
    FROM employees
    WHERE employee_id = v_empid;
    RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_hiredate)/12);
END;
/

SELECT hire_date FROM employees WHERE employee_id = 100;
SELECT emp_year(100) FROM dual;

/* 9.*/
CREATE OR REPLACE FUNCTION manager_name
    (v_deptname IN departments.department_name%TYPE)
    RETURN VARCHAR2
    IS
    v_mang_name employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_mang_name
    FROM employees
    WHERE employee_id = (SELECT manager_id FROM departments
                                            WHERE department_name = v_deptname);
    RETURN v_mang_name;
END;
/

SELECT manager_name('Public Relations') FROM dual;

/* 10.*/
SELECT name, type, text FROM 
user_source;

/* 11. */
DECLARE
    v_star VARCHAR2(10) :='**********';
BEGIN
    FOR i in 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(SUBSTR(v_star, 1, i), LENGTH(v_star), '-'));
    END LOOP;
END;
/



        