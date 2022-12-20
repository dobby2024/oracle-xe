/*
파일명 : HR-Day05-Select-Join.sql

조인(JOIN)
    조인은 여러 테이블의 정보를 보는 데 사용됩니다.
    테이블을 조인하여 두 개 이상의 테이블에 있는 정보를 볼 수 있습니다.
*/

/*
Natural Join 생성
    두 테이블에서 데이터 유형과 이름이 일치하는 열을 기반으로 자동으로 테이블을 조인할 수 있습니다.
*/
SELECT department_id, department_name,
        location_id, city, country_id
FROM departments
NATURAL JOIN locations;

/*
USING 절로 조인 생성
    Natural join은 이름과 데이터 유형이 대응되는 모든 열을 사용하여 테이블 조인합니다.
*/
SELECT employee_id, last_name,
        location_id, department_id
FROM employees JOIN departments
USING(department_id);

/*
ON 절로 조인 생성
    ON 절을 사용하여 조인 조건을 지정합니다.
*/
SELECT e.employee_id, e.last_name, e.department_id,
        d.department_id, d.location_id
FROM employees e JOIN departments d
ON (e.department_id = d.department_id);

-- ON 절을 사용하여 3-Way 조인 생성
SELECT employee_id, city, department_name
FROM employees e
JOIN departments d
ON d.department_id = e.department_id
JOIN locations l
ON d.location_id = l.location_id;

-- 조인에 추가 조건 적용
SELECT e.employee_id, e.last_name, e.department_id,
        d.department_id, d.location_id, e.manager_id
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
AND e.manager_id = 149
;

SELECT e.employee_id, e.last_name, e.department_id,
        d.department_id, d.location_id, e.manager_id
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
WHERE e.manager_id = 149
;


/*
테이블 자체 조인
    ON 절을 사용하는 SELF JOIN
*/

SELECT worker.last_name emp, manager.last_name mgr
FROM employees worker JOIN employees manager
ON (worker.manager_id = manager.employee_id);

/*
Nonequijoin
    Nonequijoin은 등호 연산자 외의 다른 연산자를 포함하는 조인 조건입니다.
    
    
CREATE TABLE job_grades (
grade_level 		CHAR(1),
lowest_sal 	NUMBER(8,2) NOT NULL,
highest_sal	NUMBER(8,2) NOT NULL
);
ALTER TABLE job_grades
ADD CONSTRAINT jobgrades_grade_pk PRIMARY KEY (grade_level);
INSERT INTO job_grades VALUES ('A', 1000, 2999);
INSERT INTO job_grades VALUES ('B', 3000, 5999);
INSERT INTO job_grades VALUES ('C', 6000, 9999);
INSERT INTO job_grades VALUES ('D', 10000, 14999);
INSERT INTO job_grades VALUES ('E', 15000, 24999);
INSERT INTO job_grades VALUES ('F', 25000, 40000);
COMMIT;
*/




















