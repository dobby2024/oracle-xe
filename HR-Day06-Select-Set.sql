/*
파일명 : HR-Day06-Select-Set.sql

집합 연산자
    SELECT 리스트의 표현식은 개수가 일치해야 합니다.
    데이터 유형은 첫번째 QUERY 데이터 유형과 일치해야 합니다.
    UNION, UNION ALL, INTERSECT, MINUS
*/


/*
UNION 연산자
    중복 행이 제거된 두 QUERY의 행
*/
SELECT employee_id, job_id
FROM employees
UNION
SELECT employee_id, job_id
FROM job_history
;
/*
UNION ALL 연산자
    중복 행이 포함된 두 query의 행
*/

SELECT employee_id, job_id, department_id
FROM employees
UNION ALL
SELECt employee_id, job_id, department_id
FROM job_history
ORDER BY employee_id
;

/*
INTERSECT 연산자
    두 query의 공통적인 행 (교집합)
*/
SELECT employee_id, job_id
FROM employees
INTERSECT 
SELECT employee_id, job_id
FROM job_history
;

/*
!주의> 데이터 유형을 일치시켜야 합니다.
*/

SELECT location_id, department_name "Department",
        TO_CHAR(NULL) "Warehouse location"
FROM departments
UNION
SELECT location_id, TO_CHAR(NULL) "Department",
        state_province
FROM locations
;

DESCRIBE departments;
DESC departments;
DESC locations;

/*
[기본형식]
    SELECT 컬럼명1, 컬럼명2...                           5
    FROM 테이블명                                        1
    WHERE 조건절                                         2
    GROUP BY 컬럼명                                      3
    HAVING 조건절                                        4
    ORDER BY 컬럼명[ASC|DESC] => 오름차순|내림차순         6 
*/

SELECT t.employee_id, t.name
FROM (
    SELECT employee_id, first_name AS name
    FROM employees
    ORDER BY name 
) t
WHERE t.name like '%a%'
;
















