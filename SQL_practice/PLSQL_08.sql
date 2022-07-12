/* 
레코드(RECORD)
*/

SET SERVEROUTPUT ON;

DESC departments;
SELECT * FROM departments;


DECLARE
    -- 정의
    TYPE dept_record_type IS RECORD 
    (
        -- 필드 타입
        -- 고유의 필드 명을 기준으로 액세스
        -- 레코드에 값 할당은 SELECT, 또는 FETCH 문을 사용하여 레코드에 일반 값 할당 가능
    deptid departments.department_id%TYPE,
    deptname departments.department_name%TYPE,
    loc departments.location_id%TYPE
    );
    -- 변수를 선언할 때 사용
    dept_record dept_record_type;
BEGIN
    SELECT department_id, department_name, location_id
    INTO dept_record
    FROM departments
    WHERE department_id = &deptno;
    DBMS_OUTPUT.PUT_LINE(dept_record.deptid);
    DBMS_OUTPUT.PUT_LINE(dept_record.deptname);
    DBMS_OUTPUT.PUT_LINE(dept_record.loc);
END;
/

-- %ROWTYPE
-- 한 행을 단위로 함, 데이터베이스 테이블 또는 뷰의 열 모음에 따라 변수 선언
-- 레코드 필드의 이름과 데이터 유형은 테이블 또는 뷰에서 가지고 옴
DECLARE
    dept_record departments%ROWTYPE;
BEGIN

--    전체 행을 다 조회
--    SELECT *
--    INTO dept_record
--    FROM departments
--    WHERE department_id = &deptno;

    -- FIELD를 이용한 접근
    SELECT department_id, department_name, location_id
    INTO dept_record.department_id, dept_record.department_name, dept_record.location_id
    FROM departments
    WHERE department_id = &deptno;
    DBMS_OUTPUT.PUT_LINE(dept_record.department_id);
    DBMS_OUTPUT.PUT_LINE(dept_record.department_name);
    DBMS_OUTPUT.PUT_LINE(dept_record.location_id);
    
END;
/

DESC departments;