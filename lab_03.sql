-- 1. Stworzyć blok anonimowy wypisujący zmienną numer_max równą maksymalnemu numerowi Departamentu i dodaj do tabeli departamenty – departament z numerem o 10 wiekszym, typ pola dla zmiennej z nazwą nowego departamentu (zainicjować na EDUCATION) ustawić taki jak dla pola department_name w tabeli (%TYPE)
DECLARE
    numer_max NUMBER;
    nowy_departament DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
BEGIN
    SELECT MAX(DEPARTMENT_ID) INTO numer_max FROM DEPARTMENTS;
    DBMS_OUTPUT.PUT_LINE('Maksymalny numer departamentu to: ' || numer_max);
    INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
    VALUES (numer_max + 10, nowy_departament);
    COMMIT;
END;


-- 2. Do poprzedniego skryptu dodaj instrukcje zmieniającą location_id (3000) dla dodanego departamentu
-- Zadeklaruj zmienne numer_max i nowy_departament
DECLARE
    numer_max NUMBER;
    nowy_departament DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
BEGIN
    SELECT MAX(DEPARTMENT_ID) INTO numer_max FROM DEPARTMENTS;
    DBMS_OUTPUT.PUT_LINE('Maksymalny numer departamentu to: ' || numer_max);
    INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
    VALUES (numer_max + 10, nowy_departament);
    UPDATE DEPARTMENTS
    SET LOCATION_ID = 3000
    WHERE DEPARTMENT_ID = numer_max + 10;
    COMMIT;
END;


-- 3. Stwórz tabelę nowa z jednym polem typu varchar a następnie wpisz do niej za pomocą pętli liczby od 1 do 10 bez liczb 4 i 6
DECLARE
    i NUMBER := 1;
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE NOWA (LICZBA VARCHAR(10))';
    WHILE i <= 10 LOOP
        IF i <> 4 AND i <> 6 THEN
        EXECUTE IMMEDIATE 'INSERT INTO NOWA VALUES (:1)' USING TO_CHAR(i);
        END IF;
        i := i + 1;
    END LOOP;
END;

SELECT * FROM NOWA;

-- 4. Wyciągnąć informacje z tabeli countries do jednej zmiennej (%ROWTYPE) dla kraju o identyfikatorze ‘CA’. Wypisać nazwę i region_id na ekran
-- Zadeklaruj zmienną kraj typu %ROWTYPE, która będzie przechowywać rekord z tabeli countries
DECLARE
    kraj COUNTRIES%ROWTYPE;
BEGIN
    SELECT * INTO kraj FROM COUNTRIES WHERE COUNTRY_ID = 'CA';
    DBMS_OUTPUT.PUT_LINE('Nazwa kraju: ' || kraj.COUNTRY_NAME);
    DBMS_OUTPUT.PUT_LINE('Region ID: ' || kraj.REGION_ID);
END;

-- 5. Za pomocą tabeli INDEX BY wyciągnąć informacje o nazwach departamentów i wypisać na ekran 10 (numery 10,20,…,100)
-- Zadeklaruj typ tabeli INDEX BY, który będzie przechowywać nazwy departamentów
DECLARE
    TYPE tablica_departamentow IS TABLE OF VARCHAR(30) INDEX BY BINARY_INTEGER;
    departamenty tablica_departamentow;
    i BINARY_INTEGER;
BEGIN
    i := 10;
    FOR r IN (SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS) LOOP
        departamenty(r.DEPARTMENT_ID) := r.DEPARTMENT_NAME;
    END LOOP;
    WHILE i <= 100 LOOP
        DBMS_OUTPUT.PUT_LINE('Departament ' || i || ': ' || departamenty(i));
        i := i + 10;
    END LOOP;
END;


-- 6. Zmienić skrypt z 5 tak aby pojawiały się wszystkie informacje na ekranie (wstawić %ROWTYPE do tabeli)
DECLARE
    TYPE tablica_departamentow IS TABLE OF DEPARTMENTS%ROWTYPE INDEX BY BINARY_INTEGER;
    departamenty tablica_departamentow;
    i BINARY_INTEGER;
BEGIN
    i := 10;
    FOR r IN (SELECT * FROM DEPARTMENTS) LOOP
        departamenty(r.DEPARTMENT_ID) := r;
    END LOOP;
    WHILE i <= 100 LOOP
        DBMS_OUTPUT.PUT_LINE('Departament ' || i || ': ');
        DBMS_OUTPUT.PUT_LINE('ID: ' || departamenty(i).DEPARTMENT_ID);
        DBMS_OUTPUT.PUT_LINE('Nazwa: ' || departamenty(i).DEPARTMENT_NAME);
        DBMS_OUTPUT.PUT_LINE('Menadżer ID: ' || departamenty(i).MANAGER_ID);
        DBMS_OUTPUT.PUT_LINE('Lokalizacja ID: ' || departamenty(i).LOCATION_ID);
        i := i + 10;
    END LOOP;
END;


-- 7. Zadeklaruj kursor jako wynagrodzenie, nazwisko dla departamentu o numerze 50. Dla elementów kursora wypisać na ekran, jeśli wynagrodzenie jest wyższe niż 3100: nazwisko osoby i tekst ‘nie dawać podwyżki’ w przeciwnym przypadku: nazwisko + ‘dać podwyżkę’
DECLARE
    CURSOR c_departament_50 IS
        SELECT SALARY, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;
    v_wynagrodzenie NUMBER;
    v_nazwisko VARCHAR(20);
BEGIN
    OPEN c_departament_50;
    LOOP
        FETCH c_departament_50 INTO v_wynagrodzenie, v_nazwisko;
        EXIT WHEN c_departament_50%NOTFOUND;
        IF v_wynagrodzenie > 3100 THEN
        DBMS_OUTPUT.PUT_LINE(v_nazwisko || ': nie dawać podwyżki');
        ELSE
        DBMS_OUTPUT.PUT_LINE(v_nazwisko || ': dać podwyżkę');
        END IF;
    END LOOP;
    CLOSE c_departament_50;
END;


-- 8. Zadeklarować kursor zwracający zarobki imię i nazwisko pracownika z parametrami, gdzie pierwsze dwa parametry określają widełki zarobków a trzeci część imienia pracownika. Wypisać na ekran pracowników:
--      a. z widełkami 1000- 5000 z częścią imienia a (może być również A)
DECLARE
    CURSOR c_pracownik (p_min NUMBER, p_max NUMBER, p_imie VARCHAR) IS
        SELECT SALARY, FIRST_NAME || ' ' || LAST_NAME AS IMIE_NAZWISKO
        FROM EMPLOYEES
        WHERE SALARY BETWEEN p_min AND p_max
        AND UPPER(FIRST_NAME) LIKE '%' || UPPER(p_imie) || '%';
    v_zarobki NUMBER;
    v_imie_nazwisko VARCHAR(40);
BEGIN
    OPEN c_pracownik(1000, 5000, 'a');
    LOOP
        FETCH c_pracownik INTO v_zarobki, v_imie_nazwisko;
        EXIT WHEN c_pracownik%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Przypadek a: ' || v_zarobki || ', ' || v_imie_nazwisko);
    END LOOP;
    CLOSE c_pracownik;
END;

--      b. z widełkami 5000-20000 z częścią imienia u (może być również U)
DECLARE
    CURSOR c_pracownik (p_min NUMBER, p_max NUMBER, p_imie VARCHAR) IS
        SELECT SALARY, FIRST_NAME || ' ' || LAST_NAME AS IMIE_NAZWISKO
        FROM EMPLOYEES
        WHERE SALARY BETWEEN p_min AND p_max
        AND UPPER(FIRST_NAME) LIKE '%' || UPPER(p_imie) || '%';
    v_zarobki NUMBER;
    v_imie_nazwisko VARCHAR(40);
BEGIN
    OPEN c_pracownik(5000, 20000, 'u');
    LOOP
        FETCH c_pracownik INTO v_zarobki, v_imie_nazwisko;
        EXIT WHEN c_pracownik%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Przypadek b: ' || v_zarobki || ', ' || v_imie_nazwisko);
    END LOOP;
    CLOSE c_pracownik;
END;


-- 9.  Stwórz procedury:
--      a. dodającą wiersz do tabeli Jobs – z dwoma parametrami wejściowymi określającymi Job_id, Job_title, przetestuj działanie wrzuć wyjątki – co najmniej when others
CREATE OR REPLACE PROCEDURE add_job (p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
BEGIN
    INSERT INTO jobs (job_id, job_title)
    VALUES (p_job_id, p_job_title);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END;

--      b. modyfikującą title w  tabeli Jobs – z dwoma parametrami id dla którego ma być modyfikacja oraz nową wartość dla Job_title – przetestować działanie, dodać swój wyjątek dla no Jobs updated – najpierw sprawdzić numer błędu
CREATE OR REPLACE PROCEDURE modify_job (p_job_id IN jobs.job_id%TYPE, p_job_title IN jobs.job_title%TYPE)
IS
    v_rows_updated NUMBER;
BEGIN
    UPDATE jobs
    SET job_title = p_job_title
    WHERE job_id = p_job_id;

    v_rows_updated := SQL%ROWCOUNT;

    IF v_rows_updated = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie zaktualizowano żadnych stanowisk');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END;

--      c. usuwającą wiersz z tabeli Jobs  o podanym Job_id– przetestować działanie, dodaj wyjątek dla no Jobs deleted
CREATE OR REPLACE PROCEDURE delete_job (p_job_id IN jobs.job_id%TYPE)
IS
    v_rows_deleted NUMBER;
BEGIN
    DELETE FROM jobs
    WHERE job_id = p_job_id;

    v_rows_deleted := SQL%ROWCOUNT;

    IF v_rows_deleted = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nie usunięto żadnych stanowisk');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END;

--      d. Wyciągającą zarobki i nazwisko (parametry zwracane przez procedurę) z tabeli employees dla pracownika o przekazanym jako parametr id
CREATE OR REPLACE PROCEDURE get_employee_salary (p_employee_id IN employees.employee_id%TYPE, p_salary OUT employees.salary%TYPE, p_last_name OUT employees.last_name%TYPE)
IS
BEGIN
    SELECT salary, last_name INTO p_salary, p_last_name FROM employees WHERE employee_id = p_employee_id;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END;

--      e. dodającą do tabeli employees wiersz – większość parametrów ustawić na domyślne (id poprzez sekwencję), stworzyć wyjątek jeśli wynagrodzenie dodawanego pracownika jest wyższe niż 20000
CREATE OR REPLACE PROCEDURE add_employee (p_salary IN employees.salary%TYPE)
IS
BEGIN
    IF p_salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Wynagrodzenie dodawanego pracownika jest wyższe niż 20000');
    ELSE
        INSERT INTO employees (employee_id, salary) VALUES (employees_seq.NEXTVAL, p_salary);
    END IF;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END;
