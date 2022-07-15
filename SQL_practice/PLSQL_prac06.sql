/* 
주민등록번호를 입력하였을 때 나이와 성별 구하기
*/
CREATE OR REPLACE PACKAGE yd_pkg
IS
    PROCEDURE y_age
        (v_ssn IN VARCHAR2);
    PROCEDURE y_sex 
        (v_ssn IN VARCHAR2);
END yd_pkg;
/

-- 조건식 2
-- IF SUBSTR(v_ssn, 7, 1) IN (1, 2) THEN => 2000년대 이전 출생자
CREATE OR REPLACE PACKAGE BODY yd_pkg
IS
    PROCEDURE y_age
        (v_ssn IN VARCHAR2)
    IS
        v_age NUMBER;
    BEGIN
        v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(v_ssn, 1, 6), 'RRMMDD'))/12);
        DBMS_OUTPUT.PUT_LINE(v_age);
    END y_age;
    PROCEDURE y_sex
        (v_ssn IN VARCHAR2)
    IS
        v_sex VARCHAR2(10);
    BEGIN
        v_sex := SUBSTR(v_ssn, 7, 1);
        IF MOD(v_sex, 2) != 0 THEN
            v_sex := 'Male';
        ELSE
            v_sex := 'Female';
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_sex);
    END y_sex;
END yd_pkg;
/

EXECUTE yd_pkg.y_age('891201167666');
EXECUTE yd_pkg.y_sex('891201167666');

CREATE OR REPLACE PACKAGE yd_pkg2
IS
    FUNCTION y_age
        (v_ssn IN VARCHAR2)
        RETURN NUMBER;
    FUNCTION y_sex
        (v_ssn IN VARCHAR2)
        RETURN VARCHAR2;
END yd_pkg2;
/

CREATE OR REPLACE PACKAGE BODY yd_pkg2
IS
    FUNCTION y_age
        (v_ssn IN VARCHAR2)
        RETURN NUMBER
        IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(v_ssn, 1, 6), 'RRMMDD'))/12);
    END y_age;
    FUNCTION y_sex
        (v_ssn IN VARCHAR2)
        RETURN VARCHAR2
        IS
        v_sex VARCHAR2(10);
    BEGIN
        IF MOD(v_ssn, 2) != 0 THEN
            v_sex := 'Male';
        ELSE
            v_sex :='Female';
        END IF;
        RETURN v_sex;
    END y_sex;
END yd_pkg2;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(yd_pkg2.y_age('891201167666'));
EXECUTE DBMS_OUTPUT.PUT_LINE(yd_pkg2.y_sex('891201167666'));