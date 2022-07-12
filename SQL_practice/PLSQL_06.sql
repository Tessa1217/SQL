-- IF, INSERT
DECLARE
    v_emp_id NUMBER :=&v_emp_id;
    v_dept_id employees.department_id%TYPE;
    v_last_name employees.last_name%TYPE;
    v_email employees.email%TYPE;
    v_sal employees.salary%TYPE;
    v_job_id employees.job_id%TYPE;
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT last_name, email, salary, job_id, hire_date, department_id
    INTO v_last_name, v_email, v_sal, v_job_id, v_hire_date, v_dept_id
    FROM employees
    WHERE employee_id = v_emp_id;
    IF v_dept_id = 10 THEN
        INSERT INTO emp10(last_name, email, salary, job_id, hire_date) VALUES(v_last_name, v_email, v_sal, v_job_id, v_hire_date);
    ELSIF v_dept_id = 20 THEN
         INSERT INTO emp20(last_name, email, salary, job_id, hire_date) VALUES(v_last_name, v_email, v_sal, v_job_id, v_hire_date);
    ELSIF v_dept_id = 30 THEN
        INSERT INTO emp30(last_name, email, salary, job_id, hire_date) VALUES(v_last_name, v_email, v_sal, v_job_id, v_hire_date);
    ELSIF v_dept_id = 40 THEN
       INSERT INTO emp40(last_name, email, salary, job_id, hire_date) VALUES(v_last_name, v_email, v_sal, v_job_id, v_hire_date);
    ELSIF v_dept_id = 50 THEN
      INSERT INTO emp50(last_name, email, salary, job_id, hire_date) VALUES(v_last_name, v_email, v_sal, v_job_id, v_hire_date);
    ELSE
      INSERT INTO emp00(last_name, email, salary, job_id, hire_date) VALUES(v_last_name, v_email, v_sal, v_job_id, v_hire_date);
    END IF;
END;
/

-- %ROWTYPE
DECLARE
    v_emp_id NUMBER :=&v_emp_id;
    v_employee employees%ROWTYPE;
BEGIN
    SELECT *
    INTO v_employee
    FROM employees
    WHERE employee_id = v_emp_id;
    IF v_employee.department_id = 10 THEN
        INSERT INTO emp10 VALUES v_employee;
    ELSIF v_employee.department_id = 20 THEN
         INSERT INTO emp20 VALUES v_employee;
    ELSIF v_employee.department_id = 30 THEN
       INSERT INTO emp30 VALUES v_employee;
    ELSIF v_employee.department_id = 40 THEN
        INSERT INTO emp40 VALUES v_employee;
    ELSIF v_employee.department_id = 50 THEN
        INSERT INTO emp50 VALUES v_employee;
    ELSE
        INSERT INTO emp00 VALUES v_employee;
    END IF;
END;
/

SELECT * FROM EMP10;


DECLARE
    v_emp_id NUMBER :=&v_emp_id;
    v_sal employees.salary%TYPE;
    v_name employees.last_name%TYPE;
    v_inc_sal NUMBER :=0;
BEGIN
    SELECT last_name, salary
    INTO v_name, v_sal
    FROM employees
    WHERE employee_id = v_emp_id;
    IF v_sal <= 5000 THEN
        v_inc_sal := v_sal * 1.2;
    ELSIF v_sal <= 10000 THEN
        v_inc_sal := v_sal * 1.15;
    ELSIF v_sal <= 15000 THEN
        v_inc_sal := v_sal * 1.1;
    ELSE
        v_inc_sal := v_sal;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_name || ' Employee Salary: ' || v_sal || ' Employee Increased Salary:' || v_inc_sal); 
END;
/

-- delete employee if employee_id is matched, else print a message
DECLARE
    v_emp_id NUMBER :=&v_emp_id;
BEGIN
    DELETE FROM emp00
    WHERE employee_id = v_emp_id;
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No such employee in this table');
    END IF;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Delete success');
    END IF;
END;
/

SELECT * FROM emp00;