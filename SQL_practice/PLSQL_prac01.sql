-- 테이블 생성 
CREATE TABLE aaa(
    a NUMBER(4)
);

CREATE TABLE bbb(
    b NUMBER(4)
);

/* 
1.
aaa 테이블에 1부터10까지 입력되도록 PL/SQL 블록을 작성하시오.
단, insert 문은 1번에 사용
*/
-- FOR
BEGIN
    FOR counter in 1..10 LOOP
        INSERT INTO aaa VALUES(counter);
    END LOOP;
END;
/

-- LOOP
DECLARE
    v_counter NUMBER :=1;
BEGIN
    LOOP
        INSERT INTO aaa VALUES(v_counter);
        v_counter := v_counter + 1; 
        EXIT WHEN v_counter > 10;
    END LOOP;
END;
/

-- WHILE
DECLARE
    v_counter NUMBER :=1;
BEGIN
    WHILE v_counter <= 10 LOOP
        INSERT INTO aaa VALUES(v_counter);
        v_counter := v_counter + 1;
    END LOOP;
END;
/

/* 
2.
bbb 테이블에 1부터 10까지 최종 합계 값을 PL/SQL 블록으로 작성하여 입력하시오.
*/
-- LOOP
DECLARE 
    v_counter NUMBER :=1;
    v_sum NUMBER :=0;
BEGIN
    LOOP
        v_sum := v_sum + v_counter;
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 10;
    END LOOP;
    INSERT INTO bbb VALUES(v_sum);
END;
/
-- WHILE LOOP
DECLARE 
    v_counter NUMBER :=1;
    v_sum NUMBER :=0;
BEGIN
    WHILE v_counter <= 10 LOOP
        v_sum := v_sum + v_counter;
        v_counter := v_counter + 1;
    END LOOP;
    INSERT INTO bbb VALUES(v_sum);
END;
/
-- FOR LOOP
DECLARE 
    v_sum NUMBER :=0;
BEGIN
    FOR counter in 1..10 LOOP
        v_sum := v_sum + counter;
    END LOOP;
    INSERT INTO bbb VALUES(v_sum);
END;
/
-- USING TABLE aaa
DECLARE
    v_sum NUMBER;
BEGIN
    SELECT SUM(a)
    INTO v_sum
    FROM aaa;
    INSERT INTO bbb VALUES(v_sum);
END;
/

/* 
3
aaa 테이블에 1부터 10까지 짝수만 입력되도록 PL/SQL 블록을 작성하시오.
단, insert 문은 한번 사용, if문 사용
*/
-- FOR LOOP
BEGIN
    FOR counter in 1..10 LOOP
        IF MOD(counter, 2) = 0 THEN
            INSERT INTO aaa VALUES(counter);
        END IF;
    END LOOP;
END;
/
-- WHILE LOOP
DECLARE
    v_counter NUMBER :=1;
BEGIN
    WHILE v_counter <= 10 LOOP
        IF MOD(v_counter, 2) = 0 THEN
            INSERT INTO aaa VALUES(v_counter);
        END IF;
        v_counter := v_counter + 1;
    END LOOP;
END;
/
-- LOOP
DECLARE
    v_counter NUMBER :=1;
BEGIN
    LOOP
        IF MOD(v_counter, 2) = 0 THEN
            INSERT INTO aaa VALUES(v_counter);
        END IF;
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 10;
    END LOOP;
END;
/

/* 
4.
bbb 테이블에 1부터 10까지 짝수 최종 합계 값을 PL/SQL 블록으로 작성하여 입력하시오.
단, if문 사용
*/
-- LOOP
DECLARE
    v_counter NUMBER :=1;
    v_sum NUMBER :=0;
BEGIN
    LOOP
        IF MOD(v_counter, 2) = 0 THEN
            v_sum := v_sum + v_counter;
        END IF;
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 10;
    END LOOP;
    INSERT INTO bbb VALUES(v_sum);
END;
/
-- FOR
DECLARE
    v_sum NUMBER :=0;
BEGIN
    FOR counter in 1..10 LOOP
        IF MOD(counter, 2) = 0 THEN
            v_sum := v_sum + counter;
        END IF;
    END LOOP;
    INSERT INTO bbb VALUES(v_sum);
END;
/
-- WHILE
DECLARE
    v_counter NUMBER :=1;
    v_sum NUMBER :=0;
BEGIN
    WHILE v_counter <= 10 LOOP
        IF MOD(v_counter, 2) = 0 THEN
            v_sum := v_sum + v_counter;
        END IF;
        v_counter := v_counter + 1;
    END LOOP;
    INSERT INTO bbb VALUES(v_sum);
END;
/

/* 
5.
1부터 10까지에서 짝수의 합계는 aaa 테이블에, 홀수의 합계는 bbb 테이블에 
입력되도록 PL/SQL 블록을 작성하시오. (단, if 문 사용)
*/
-- FOR
DECLARE
    v_odd_sum NUMBER :=0;
    v_even_sum NUMBER :=0;
BEGIN
    FOR counter in 1..10 LOOP
        IF MOD(counter, 2) = 0 THEN
            v_even_sum := v_even_sum + counter;
        ELSIF MOD(counter, 2) != 0 THEN
            v_odd_sum := v_odd_sum + counter;
        END IF;
    END LOOP;
    INSERT INTO aaa VALUES(v_even_sum);
    INSERT INTO bbb VALUES(v_odd_sum);
END;
/
-- WHILE
DECLARE
    v_odd_sum NUMBER :=0;
    v_even_sum NUMBER :=0;
    v_counter NUMBER :=1;
BEGIN
    WHILE v_counter <= 10 LOOP
        IF MOD(v_counter, 2) = 0 THEN
            v_even_sum := v_even_sum + v_counter;
        ELSE 
            v_odd_sum := v_odd_sum + v_counter;
        END IF;
        v_counter := v_counter + 1;
    END LOOP;
    INSERT INTO aaa VALUES(v_even_sum);
    INSERT INTO bbb VALUES(v_odd_sum);
END;
/
-- LOOP
DECLARE
    v_odd_sum NUMBER :=0;
    v_even_sum NUMBER :=0;
    v_counter NUMBER :=1;
BEGIN
    LOOP
        IF MOD(v_counter, 2) = 0 THEN
            v_even_sum := v_even_sum + v_counter;
        ELSE 
            v_odd_sum := v_odd_sum + v_counter;
        END IF;
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 10;
    END LOOP;
    INSERT INTO aaa VALUES(v_even_sum);
    INSERT INTO bbb VALUES(v_odd_sum);
END;
/