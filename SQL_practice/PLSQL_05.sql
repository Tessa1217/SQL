/* 
If문: 만족되는 조건에 따라 선택적으로 작업 수행 (TRUE일 때만 실행)
IF condition THEN
    statements;
[ELSIF condition THEN
    statements;]
[ELSE statements;]
END IF;
-- IF문의 끝은 반드시 명시적으로 종료해줘야 하므로 END IF는 필수 
*/

-- IF Practice 1
DECLARE
    v_age NUMBER :=&age;
BEGIN
    IF v_age < 20 THEN
        DBMS_OUTPUT.PUT_LINE('Teenager');
    ELSIF v_age > 60 THEN
        DBMS_OUTPUT.PUT_LINE('Elderly');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Adult');
    END IF;
END;
/

-- IF Practice 2
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees 
    WHERE employee_id = &empno;
    IF v_ename = 'Popp' THEN
        DBMS_OUTPUT.PUT_LINE('Popp has been selected');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Popp has not been selected');
    END IF;
END;
/

DECLARE
    v_myage number := &v_myage;
BEGIN
    IF v_myage < 11 THEN
        DBMS_OUTPUT.PUT_LINE('I am a child');
    ELSIF v_myage < 20 THEN
        DBMS_OUTPUT.PUT_LINE('I am a teenager');
    ELSIF v_myage < 30 THEN
        DBMS_OUTPUT.PUT_LINE('I am in my twenties');
    ELSIF v_myage < 40 THEN
        DBMS_OUTPUT.PUT_LINE('I am in my thirties');
    ELSE
        DBMS_OUTPUT.PUT_LINE('I am a full-grown adult');
    END IF;
END;
/