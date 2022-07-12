SET SERVEROUTPUT ON;
/* 
Loop
- LOOP
- FOR LOOP
- WHILE LOOP
*/

-- LOOP
DECLARE
    v_country_id locations.country_id%TYPE := 'US';
    v_loc_id locations.location_id%TYPE;
    v_counter NUMBER(2) := 1;
    v_new_city locations.city%TYPE := 'New York';
BEGIN
    SELECT MAX(location_id) 
    INTO v_loc_id 
    FROM locations 
    WHERE country_id = v_country_id;
    LOOP 
        INSERT INTO locations(location_id, city, country_id) 
        VALUES ((v_loc_id + v_counter), v_new_city, v_country_id);
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 3;
    END LOOP;
END;
/

SELECT * FROM locations;

DELETE FROM locations WHERE location_id between 1701 AND 1704;

-- FOR LOOP
DECLARE 
    v_country_id locations.country_id%TYPE := 'CA';
    v_loc_id locations.location_id%TYPE;
    v_new_city locations.city%TYPE := 'Montreal';
BEGIN
    SELECT MAX(location_id)
    INTO v_loc_id
    FROM locations
    WHERE country_id = v_country_id;
    FOR counter in 1..3 LOOP
        INSERT INTO locations (location_id, city, country_id) 
        VALUES ((v_loc_id + counter), v_new_city, v_country_id);
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
    END LOOP;
END;
/

SELECT * FROM locations;

SELECT * FROM employees;

DECLARE 
    v_country_id locations.country_id%TYPE := 'CA';
    v_loc_id locations.location_id%TYPE;
    v_new_city locations.city%TYPE := 'Montreal';
    v_counter NUMBER :=1;
BEGIN
    SELECT MAX(location_id)
    INTO v_loc_id
    FROM locations
    WHERE country_id = v_country_id;
    WHILE v_counter <= 3 LOOP
        INSERT INTO locations(location_id, city, country_id) 
        VALUES ((v_loc_id + v_counter), v_new_city, v_country_id);
        v_counter := v_counter + 1;
    END LOOP;
END;
/

SELECT * FROM locations;

SET SERVEROUT ON;

-- WHILE LOOP
DECLARE
    v_counter NUMBER := 1;
    v_star VARCHAR2(100) :='*';
    v_message VARCHAR2(100);
BEGIN
    WHILE v_counter <= 5 LOOP
        v_message := CONCAT(v_message, v_star);
        DBMS_OUTPUT.PUT_LINE(v_message);
        v_counter := v_counter + 1;
    END LOOP;
END;
/

-- LOOP
DECLARE
    v_counter NUMBER := 1;
    v_result VARCHAR2(100);
BEGIN
    LOOP
        v_result := CONCAT(v_result, '*');
        DBMS_OUTPUT.PUT_LINE(v_result);
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 5;
    END LOOP;
END;
/

-- FOR LOOP
DECLARE
    v_result VARCHAR2(100);
BEGIN
    FOR counter in 1..5 LOOP
        v_result := CONCAT(v_result, '*');
        DBMS_OUTPUT.PUT_LINE(v_result);
    END LOOP;
END;
/

-- ±¸±¸´Ü
-- FOR LOOP
DECLARE
    v_num NUMBER :=&num;
BEGIN
    FOR counter in 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_num || ' * ' || counter || ' = ' || (v_num * counter));  
    END LOOP;
END;
/

-- LOOP
DECLARE
    v_num NUMBER := &num;
    v_counter NUMBER :=1;
BEGIN
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_num || ' * ' || v_counter || ' = ' || (v_num * v_counter));  
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 9;
    END LOOP;
END;
/

-- WHILE
DECLARE
    v_num NUMBER := &num;
    v_counter NUMBER :=1;
BEGIN
    WHILE v_counter <= 9 LOOP 
        DBMS_OUTPUT.PUT_LINE(v_num || ' * ' || v_counter || ' = ' || (v_num * v_counter));  
        v_counter := v_counter + 1;
    END LOOP;
END;
/

-- ±¸±¸´Ü 2~9´Ü±îÁö
-- WHILE LOOP
DECLARE
    v_num NUMBER := 2;
    v_counter NUMBER := 1;
BEGIN
    WHILE v_num <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE('==== '|| v_num || '´Ü ' || '====');
        WHILE v_counter <= 9 LOOP
           DBMS_OUTPUT.PUT_LINE(v_num || ' * ' || v_counter || ' = ' || (v_num * v_counter));  
           v_counter := v_counter + 1;
        END LOOP;
        v_num := v_num + 1;
        v_counter := 1;
    END LOOP;
END;
/

-- FOR LOOP
BEGIN
    FOR number in 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE('==== '|| number  || '´Ü ' || '====');
        FOR counter in 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(number || ' * ' || counter || ' = ' || (number * counter));
        END LOOP;
    END LOOP;
END;
/

-- ±¸±¸´Ü 1~9´Ü±îÁö È¦¼ö´Ü¸¸ Ãâ·Â
-- WHILE
DECLARE
    v_num NUMBER := 1;
    v_counter NUMBER := 1;
BEGIN
    WHILE v_num <= 9 LOOP
        IF MOD(v_num, 2) = 1 THEN
            DBMS_OUTPUT.PUT_LINE('==== '|| v_num || '´Ü ' || '====');
            WHILE v_counter <= 9 LOOP
               DBMS_OUTPUT.PUT_LINE(v_num || ' * ' || v_counter || ' = ' || (v_num * v_counter));  
               v_counter := v_counter + 1;
            END LOOP;
        END IF;
        v_num := v_num + 1;
        v_counter := 1;
    END LOOP;
END;
/

-- FOR
BEGIN
    FOR number in 1..9 LOOP
        IF MOD(number,2) = 1 THEN
            DBMS_OUTPUT.PUT_LINE('==== '|| number || '´Ü ' || '====');
            FOR counter in 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(number || ' * ' || counter || ' = ' || (number * counter));
            END LOOP;
        END IF;
    END LOOP;
END;
/

-- ¶ì ±¸ÇÏ±â 
DECLARE 
    v_full_birthday DATE :='&birthday';
    v_birthday NUMBER;
    v_remainder NUMBER;
    v_message VARCHAR2(100);
BEGIN
    v_birthday := TO_CHAR(v_full_birthday, 'YYYY');
    v_remainder := MOD(v_birthday, 12);
    IF v_remainder = 0 THEN
        v_message := '¿ø¼þÀÌ';
    ELSIF v_remainder = 1 THEN
        v_message := '´ß';
    ELSIF v_remainder = 2 THEN 
        v_message := '°³';
    ELSIF v_remainder = 3 THEN
        v_message := 'µÅÁö';
    ELSIF v_remainder = 4 THEN
        v_message := 'Áã';
    ELSIF v_remainder = 5 THEN
        v_message := '¼Ò';
    ELSIF v_remainder = 6 THEN
        v_message := 'È£¶ûÀÌ';
    ELSIF v_remainder = 7 THEN
        v_message := 'Åä³¢';
    ELSIF v_remainder = 8 THEN
        v_message := '¿ë';
    ELSIF v_remainder = 9 THEN  
        v_message := '¹ì';
    ELSIF v_remainder = 10 THEN
        v_message := '¸»';
    ELSIF v_remainder = 11 THEN
        v_message := '¾ç';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_message || '¶ì');
END;
/


    

