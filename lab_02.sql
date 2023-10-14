-- I Usuń wszystkie tabele ze swojej bazy
DROP TABLE JOB_HISTORY;
DROP TABLE DEPARTAMENTS;
DROP TABLE EMPLOYEES;
DROP TABLE LOCATIONS;
DROP TABLE COUNTRIES;
DROP TABLE REGIONS;
DROP TABLE JOBS;

-- ----------------------------------------------------------------------------------------------------------

-- II Przekopiuj wszystkie tabele wraz z danymi od użytkownika HR. Poustawiaj klucze główne i obce
-- Kopiowanie tabel z HR do LEWCZYNSKID
CREATE TABLE employees AS SELECT * FROM HR.EMPLOYEES;
CREATE TABLE departments AS SELECT * FROM HR.DEPARTMENTS;
CREATE TABLE locations AS SELECT * FROM HR.LOCATIONS;
CREATE TABLE countries AS SELECT * FROM HR.COUNTRIES;
CREATE TABLE regions AS SELECT * FROM HR.REGIONS;
CREATE TABLE jobs AS SELECT * FROM HR.JOBS;
CREATE TABLE job_history AS SELECT * FROM HR.JOB_HISTORY;
CREATE TABLE job_grades AS SELECT * FROM HR.JOB_GRADES;


-- Ustawienie kluczy głównych dla każdej tabeli
ALTER TABLE regions ADD CONSTRAINT PK_REGIONS PRIMARY KEY (REGION_ID);
ALTER TABLE countries ADD CONSTRAINT PK_COUNTRIES PRIMARY KEY (COUNTRY_ID);
ALTER TABLE locations ADD CONSTRAINT PK_LOCATIONS PRIMARY KEY (LOCATION_ID);
ALTER TABLE departments ADD CONSTRAINT PK_DEPARTMENTS PRIMARY KEY (DEPARTMENT_ID);
ALTER TABLE job_history ADD CONSTRAINT PK_JOB_HISTORY PRIMARY KEY (EMPLOYEE_ID, START_DATE);
ALTER TABLE jobs ADD CONSTRAINT PK_JOBS PRIMARY KEY (JOB_ID);
ALTER TABLE employees ADD CONSTRAINT PK_EMPLOYEES PRIMARY KEY (EMPLOYEE_ID);
ALTER TABLE job_grades ADD CONSTRAINT PK_JOB_GRADES PRIMARY KEY (GRADE);

-- Ustawienie kluczy obcych dla każdej tabeli, która ma relację z inną tabelą
ALTER TABLE EMPLOYEES ADD CONSTRAINT FK_EMPLOYEES_JOB_ID FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID);
ALTER TABLE EMPLOYEES ADD CONSTRAINT FK_EMPLOYEES_MANAGER_ID FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE EMPLOYEES ADD CONSTRAINT FK_EMPLOYEES_DEPARTMENT_ID FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID);

ALTER TABLE JOB_HISTORY ADD CONSTRAINT FK_JOB_HISTORY_EMPLOYEE_ID FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE JOB_HISTORY ADD CONSTRAINT FK_JOB_HISTORY_JOB_ID FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID);
ALTER TABLE JOB_HISTORY ADD CONSTRAINT FK_JOB_HISTORY_DEPARTMENT_ID FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID);

ALTER TABLE DEPARTMENTS ADD CONSTRAINT FK_DEPARTMENTS_LOCATION_ID FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(LOCATION_ID);

ALTER TABLE LOCATIONS ADD CONSTRAINT FK_LOCATIONS_COUNTRY_ID FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID);

ALTER TABLE COUNTRIES ADD CONSTRAINT FK_COUNTRIES_REGION_ID FOREIGN KEY (REGION_ID) REFERENCES REGIONS(REGION_ID);

-- ----------------------------------------------------------------------------------------------------------

-- III Stwórz następujące perspektywy lub zapytania, dodaj wszystko do swojego repozytorium:
-- 01. Z tabeli employees wypisz w jednej kolumnie nazwisko i zarobki – nazwij kolumnę wynagrodzenie, dla osób z departamentów 20 i 50 z zarobkami pomiędzy 2000 a 7000, uporządkuj kolumny według nazwiska
SELECT e.LAST_NAME || ' ' || e.SALARY AS WYNAGRODZENIE
FROM EMPLOYEES e
JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE d.DEPARTMENT_ID IN (20, 50)
AND e.SALARY BETWEEN 2000 AND 7000
ORDER BY e.LAST_NAME;

-- 02. Z tabeli employees wyciągnąć informację data zatrudnienia, nazwisko oraz kolumnę podaną przez użytkownika dla osób mających menadżera zatrudnionych w roku 2005. Uporządkować według kolumny podanej przez użytkownika
SELECT e.HIRE_DATE, e.LAST_NAME, e.FIRST_NAME
FROM EMPLOYEES e
JOIN EMPLOYEES m
ON e.MANAGER_ID = m.EMPLOYEE_ID
WHERE EXTRACT(YEAR FROM m.HIRE_DATE) = 2005
ORDER BY e.FIRST_NAME;

-- 03. Wypisać imiona i nazwiska  razem, zarobki oraz numer telefonu porządkując dane według pierwszej kolumny malejąco  a następnie drugiej rosnąco (użyć numerów do porządkowania) dla osób z trzecią literą nazwiska ‘e’ oraz częścią imienia podaną przez użytkownika
SELECT FIRST_NAME || ' ' || LAST_NAME AS IMIE_NAZWISKO, SALARY, PHONE_NUMBER
FROM EMPLOYEES
WHERE SUBSTR(LAST_NAME, 3, 1) = 'e' AND SUBSTR(FIRST_NAME , 1, 2) = 'Da'
ORDER BY IMIE_NAZWISKO DESC, SALARY ASC;

-- 04. Wypisać imię i nazwisko, liczbę miesięcy przepracowanych – funkcje months_between oraz round oraz kolumnę wysokość_dodatku jako (użyć CASE lub DECODE):
--     10% wynagrodzenia dla liczby miesięcy do 150
--     20% wynagrodzenia dla liczby miesięcy od 150 do 200
--     30% wynagrodzenia dla liczby miesięcy od 200
--     uporządkować według liczby miesięcy
SELECT FIRST_NAME || ' ' || LAST_NAME AS IMIE_NAZWISKO,
ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS LICZBA_MIESIECY,
CASE
    WHEN ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) <= 150 THEN SALARY * 0.1
    WHEN ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) > 150 AND ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) <= 200 THEN SALARY * 0.2
    WHEN ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) > 200 THEN SALARY * 0.3
END AS WYSOKOSC_DODATKU
FROM EMPLOYEES
ORDER BY LICZBA_MIESIECY;

-- 05. Dla każdego działów w których minimalna płaca jest wyższa niż 5000 wypisz sumę oraz średnią zarobków zaokrągloną do całości nazwij odpowiednio kolumny
SELECT d.DEPARTMENT_NAME, MIN(e.SALARY) AS MINIMALNA_PLACA, SUM(e.SALARY) AS SUMA_PLAC, ROUND(AVG(e.SALARY)) AS SREDNIA_PLACA
FROM EMPLOYEES e
JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME
HAVING MIN(e.SALARY) > 5000;

-- 06. Wypisać nazwisko, numer departamentu, nazwę departamentu, id pracy, dla osób z pracujących Toronto
SELECT e.LAST_NAME, e.DEPARTMENT_ID, d.DEPARTMENT_NAME, e.JOB_ID
FROM EMPLOYEES e
JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN LOCATIONS l
ON d.LOCATION_ID = l.LOCATION_ID
WHERE l.CITY = 'Toronto';

-- 07. Dla pracowników o imieniu „Jennifer” wypisz imię i nazwisko tego pracownika oraz osoby które z nim współpracują
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS IMIE_NAZWISKO_JENNIFER,
c.FIRST_NAME || ' ' || c.LAST_NAME AS IMIE_NAZWISKO_WSPOLPRACOWNIKA
FROM EMPLOYEES e
JOIN EMPLOYEES c
ON e.MANAGER_ID = c.MANAGER_ID
WHERE e.FIRST_NAME = 'Jennifer';

-- 08. Wypisać wszystkie departamenty w których nie ma pracowników
SELECT d.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM DEPARTMENTS d
LEFT JOIN EMPLOYEES e
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE e.EMPLOYEE_ID IS NULL;

-- 09. Skopiuj tabelę Job_grades od użytkownika HR
CREATE TABLE job_grades AS SELECT * FROM HR.JOB_GRADES;

-- 10. Wypisz imię i nazwisko, id pracy, nazwę departamentu, zarobki, oraz odpowiedni grade dla każdego pracownika
SELECT e.FIRST_NAME, e.LAST_NAME, dep.DEPARTMENT_NAME, e.SALARY, (SELECT jg.GRADE from JOB_GRADES jg WHERE e.SALARY between jg.MIN_SALARY AND jg.MAX_SALARY) AS GRADE
FROM EMPLOYEES e
JOIN DEPARTMENTS dep
ON e.DEPARTMENT_ID = dep.DEPARTMENT_ID;

-- 11. Wypisz imię nazwisko oraz zarobki dla osób które zarabiają więcej niż średnia wszystkich, uporządkuj malejąco według zarobków
SELECT FIRST_NAME || ' ' || LAST_NAME AS IMIE_NAZWISKO, SALARY
FROM EMPLOYEES
GROUP BY FIRST_NAME, LAST_NAME, SALARY
HAVING SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
ORDER BY SALARY DESC;

-- 12. Wypisz id imie i nazwisko osób, które pracują w departamencie z osobami mającymi w nazwisku „u”
SELECT e.EMPLOYEE_ID ,e.FIRST_NAME || ' ' || e.LAST_NAME AS IMIE_NAZWISKO
FROM EMPLOYEES e
WHERE e.DEPARTMENT_ID IN (SELECT UNIQUE dep.DEPARTMENT_ID 
FROM DEPARTMENTS dep
JOIN EMPLOYEES e
ON e.DEPARTMENT_ID = dep.DEPARTMENT_ID
WHERE e.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%u%'));