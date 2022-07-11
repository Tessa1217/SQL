-- 호스트 환경에서 변수 선언

SET SERVEROUTPUT ON;

-- variable 사용 
VARIABLE g_monthly_sal NUMBER;

ACCEPT p_annual_sal PROMPT 'Please enter the annual salary:';

DECLARE
    v_sal NUMBER(9, 2) :=&p_annual_sal;
BEGIN
    -- 외부에서 선언한 변수의 경우 : 사용 필요 
    :g_monthly_sal := v_sal / 12;
    DBMS_OUTPUT.PUT_LINE(:g_monthly_sal);
END;
/

