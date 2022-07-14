CREATE TABLE EMP_TEST
AS SELECT employee_id, last_name
FROM employees
WHERE employee_id < 200;

SELECT * FROM emp_test;

/* 사원번호를 사용하여 사원을 삭제, 사원이 없으면 
 사용자 정의 예외사항 사용하여 해당 사원이 없습니다  라는 오류 메시지 발생 */
DECLARE
    v_no_employee EXCEPTION;
BEGIN
    DELETE FROM emp_test
    WHERE employee_id = &empId; 
    IF SQL%NOTFOUND THEN
        RAISE v_no_employee;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('사원 삭제에 성공했습니다.');
    END IF;
EXCEPTION
    WHEN v_no_employee THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
END;
/

/* 
사원 테이블에서 사원번호를 입력 받아 10% 인상된 급여로 수정
단 2000년 이후 입사한 사원은 갱신하지 않고 메세지 출력
*/
DECLARE
    v_hire_late EXCEPTION;
    v_emp_id employees.employee_id%TYPE :=&empId;
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = v_emp_id;
    IF v_hire_date > '2000/12/31' THEN
        RAISE v_hire_late;
    ELSE 
        UPDATE employees
        SET salary = salary * 1.1
        WHERE employee_id = v_emp_id;
        IF SQL%FOUND THEN
            DBMS_OUTPUT.PUT_LINE(v_emp_id ||'번 사원의 급여가 수정되었습니다.');
        END IF;
    END IF;
EXCEPTION
    WHEN v_hire_late THEN
        DBMS_OUTPUT.PUT_LINE('2000년 이후 입사한 사원입니다.');
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE(v_emp_id ||'는 없는 사원번호입니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

DECLARE
    v_hire_late EXCEPTION;
    v_emp_id employees.employee_id%TYPE :=&empId;
    v_hire_date employees.hire_date%TYPE;
BEGIN
    -- 입력받은 사원번호를 이용해서 입사일 조회
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = v_emp_id;
    IF v_hire_date > '2000/12/31' THEN
        RAISE v_hire_late;
    END IF;
    -- 사원 입사일이 2000년 이전일 경우에 사원의 연봉 변경
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = v_emp_id;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE(v_emp_id ||'번 사원의 급여가 수정되었습니다.');   
    END IF;
EXCEPTION
    WHEN v_hire_late THEN
        DBMS_OUTPUT.PUT_LINE('2000년 이후 입사한 사원입니다.');
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE(v_emp_id ||'는 없는 사원번호입니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- CURSOR (FOR)
DECLARE
    CURSOR emp_cursor IS
        SELECT * FROM employees WHERE department_id = &deptid
        FOR UPDATE OF salary;
    emp_hiredate EXCEPTION;
    emp_no_emp EXCEPTION;
    v_count NUMBER :=0;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        BEGIN
            IF emp_record.hire_date > '2000/12/31' THEN
                RAISE emp_hiredate;
            END IF;
            UPDATE employees SET salary = salary * 1.1
            WHERE CURRENT OF emp_cursor;
            IF emp_cursor%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('업데이트 되었습니다.');
            END IF;
        EXCEPTION
             WHEN emp_hiredate THEN
                DBMS_OUTPUT.PUT_LINE('2000년 이후 입사한 사원은 갱신되지 않습니다.');
        END;
        v_count := v_count + emp_cursor%ROWCOUNT;
    END LOOP;
    IF v_count = 0 THEN
        RAISE emp_no_emp;
    END IF;
EXCEPTION
    WHEN emp_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('사원이 없습니다.');
END;
/

--CURSOR(LOOP)
DECLARE
    CURSOR emp_cursor IS
    SELECT * FROM employees WHERE department_id = &deptid
        FOR UPDATE OF salary;
    emp_no_emp EXCEPTION;
    emp_hiredate EXCEPTION;
    emp_record emp_cursor%ROWTYPE;
BEGIN
    IF NOT emp_cursor%ISOPEN THEN
        OPEN emp_cursor;
    END IF;
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        BEGIN
            IF emp_record.hire_date > '2000-12-31' THEN
                RAISE emp_hiredate;
            END IF;
            UPDATE employees SET salary = salary * 1.1 
            WHERE CURRENT OF emp_cursor;
            DBMS_OUTPUT.PUT_LINE('업데이트되었습니다.');
        EXCEPTION
            WHEN emp_hiredate THEN
                DBMS_OUTPUT.PUT_LINE('2000년도 이후 입사자입니다.');
        END;
    END LOOP;
    IF emp_cursor%ROWCOUNT = 0 THEN
        RAISE emp_no_emp;
    END IF;
    CLOSE emp_cursor;
EXCEPTION
    WHEN emp_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('사원이 없는 부서입니다.');
END;
/
SELECT * FROM employees WHERE department_id = 100;
