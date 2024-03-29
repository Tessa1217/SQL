CREATE TABLE MENU_LOG (
    MENU_LOG_NO NUMBER(30) PRIMARY KEY,
    MENU_NO NUMBER(10) NOT NULL,
    USER_NO NUMBER(15),
    MENU_LOG_IP VARCHAR2(100),
    MENU_LOG_TIME TIMESTAMP
);
CREATE SEQUENCE MENU_LOG_SEQ;
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 1, 1, '192.100.100.1', SYSTIMESTAMP);
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 1, 1, '192.100.100.1', '2021-11-10 00:00:00');
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 1, 1, '192.100.100.1', '2020-11-09 00:00:00');
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 1, 1, '192.100.100.1', '2020-10-10 00:00:30');
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 2, 1, '192.100.100.1', SYSTIMESTAMP);
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 2, 1, '192.100.100.1', '2021-12-13 00:00:10');
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 2, 1, '192.100.100.1', '2021-12-14 10:00:12');
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 2, 1, '192.100.100.1', '2020-01-01 10:28:12');
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 3, 1, '192.100.100.1', SYSTIMESTAMP);
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 3, 1, '192.100.100.1', '2022-09-01 12:13:12');
INSERT INTO MENU_LOG (MENU_LOG_NO, MENU_NO, USER_NO, MENU_LOG_IP, MENU_LOG_TIME)
VALUES (MENU_LOG_SEQ.NEXTVAL, 3, 1, '192.100.100.1', '2020-10-11 08:00:14');
SELECT * FROM MENU_LOG;

SELECT to_char(SYSTIMESTAMP - INTERVAL '1' YEAR, 'yyyy') FROM DUAL;

SELECT * FROM
(SELECT MENU_NO, TO_CHAR(MENU_LOG_TIME, 'YYYY')||'년' MENU_LOG_YEAR
FROM MENU_LOG)
PIVOT (
    COUNT(*)
    FOR MENU_LOG_YEAR IN ('2020년', '2021년', '2022년')
);

SELECT MENU_NO
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '1', 1, 0)) "1월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '2', 1, 0)) "2월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '3', 1, 0)) "3월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '4', 1, 0)) "4월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '5', 1, 0)) "5월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '6', 1, 0)) "6월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '7', 1, 0)) "7월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '8', 1, 0)) "8월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '9', 1, 0)) "9월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '10', 1, 0)) "10월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '11', 1, 0)) "11월"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'FMMM'), '12', 1, 0)) "12월"
FROM MENU_LOG
GROUP BY MENU_NO;

COMMIT;

SELECT MENU_NO
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '01', 1, 0)) "1"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '02', 1, 0)) "2"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '03', 1, 0)) "3"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '04', 1, 0)) "4"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '05', 1, 0)) "5"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '06', 1, 0)) "6"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '07', 1, 0)) "7"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '08', 1, 0)) "8"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '09', 1, 0)) "9"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '10', 1, 0)) "10"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '11', 1, 0)) "11"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '12', 1, 0)) "12"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '13', 1, 0)) "13"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '14', 1, 0)) "14"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '15', 1, 0)) "15"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '16', 1, 0)) "16"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '17', 1, 0)) "17"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '18', 1, 0)) "18"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '19', 1, 0)) "19"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '20', 1, 0)) "20"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '21', 1, 0)) "21"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '22', 1, 0)) "22"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '23', 1, 0)) "23"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'HH24'), '24', 1, 0)) "24"
FROM MENU_LOG
GROUP BY MENU_NO;

SELECT MENU_NO
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '01', 1, 0)) "1"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '02', 1, 0)) "2"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '03', 1, 0)) "3"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '04', 1, 0)) "4"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '05', 1, 0)) "5"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '06', 1, 0)) "6"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '07', 1, 0)) "7"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '08', 1, 0)) "8"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '09', 1, 0)) "9"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '10', 1, 0)) "10"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '11', 1, 0)) "11"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '12', 1, 0)) "12"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '13', 1, 0)) "13"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '14', 1, 0)) "14"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '15', 1, 0)) "15"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '16', 1, 0)) "16"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '17', 1, 0)) "17"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '18', 1, 0)) "18"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '19', 1, 0)) "19"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '20', 1, 0)) "20"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '21', 1, 0)) "21"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '22', 1, 0)) "22"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '23', 1, 0)) "23"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '24', 1, 0)) "24"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '25', 1, 0)) "25"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '26', 1, 0)) "26"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '27', 1, 0)) "27"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '28', 1, 0)) "28"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '29', 1, 0)) "29"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '30', 1, 0)) "30"
    ,  SUM(DECODE(TO_CHAR(MENU_LOG_TIME, 'DD'), '31', 1, 0)) "31"
FROM MENU_LOG
GROUP BY MENU_NO;

-- MENU PATH 파라미터 NULL이 아닐 경우 합치기
SELECT MENU_PATH||DECODE(MENU_PARAMETER, NULL, '', '&'||MENU_PARAMETER)
FROM MENU;

-- MENU가 링크면 앞에 시작 패스 찾아오고, 보드일 경우에는 뒤의 보드 타입 + 게시판 번호 찾기
SELECT 
    CASE WHEN MENU_TYPE = 'link' THEN SUBSTR(MENU_PATH, 1, INSTR(MENU_PATH, '/', 2) - 1) 
    ELSE SUBSTR(MENU_PATH||'&'||MENU_PARAMETER, INSTR(MENU_PATH, '?')) END 
FROM MENU;
