CREATE TABLE JOBS (
    JOB_ID INT NOT NULL,
    JOB_TITLE VARCHAR(50),
    MIN_SALARY DECIMAL(10, 2),
    MAX_SALARY DECIMAL(10, 2),
    CHECK(MAX_SALARY - MIN_SALARY >= 2000),
    PRIMARY KEY (JOB_ID)
);

CREATE TABLE REGIONS (
    REGION_ID INT NOT NULL,
    REGION_NAME VARCHAR(100) NOT NULL,
    PRIMARY KEY (REGION_ID)
);

CREATE TABLE COUNTRIES (
    COUNTRY_ID INT NOT NULL,
    COUNTRY_NAME VARCHAR(100),
    REGION_ID INT,
    PRIMARY KEY (COUNTRY_ID),
    FOREIGN KEY (REGION_ID) REFERENCES REGIONS(REGION_ID)
);

CREATE TABLE LOCATIONS (
    LOCATION_ID INT NOT NULL,
    STREET_ADDRESS VARCHAR(255),
    POSTAL_CODE VARCHAR(20),
    CITY VARCHAR(100),
    STATE_PROVINCE VARCHAR(100),
    COUNTRY_ID INT,
    PRIMARY KEY (LOCATION_ID),
    FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID)
);


CREATE TABLE DEPARTAMENTS (
    DEPARTMENT_ID INT NOT NULL,
    DEPARTMENT_NAME VARCHAR(255),
    MANAGER_ID INT,
    LOCATION_ID INT,
    PRIMARY KEY (DEPARTMENT_ID),
    FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(LOCATION_ID)
);

CREATE TABLE EMPLOYEES(
    EMPLOYEE_ID INT NOT NULL,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(100),
    PHONE_NUMBER VARCHAR(20),
    HIRE_DATE DATE,
    JOB_ID INT,
    SALARY DECIMAL(10, 2),
    COMMISSION_PCT VARCHAR(255),
    MANAGER_ID INT,
    DEPARTMENT_ID INT,
    PRIMARY KEY (EMPLOYEE_ID),
    FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID)
);

CREATE TABLE JOB_HISTORY (
    EMPLOYEE_ID INT NOT NULL,
    START_DATE DATE NOT NULL,
    END_DATE DATE,
    JOB_ID INT,
    DEPARTMENT_ID INT,
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTAMENTS(DEPARTMENT_ID),
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID),
    CONSTRAINT PK_JOB_HISTORY PRIMARY KEY (EMPLOYEE_ID, START_DATE)
);

ALTER TABLE DEPARTAMENTS ADD FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE EMPLOYEES ADD FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);