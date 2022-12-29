/*
ROWID와 ROWNUM
    오라클에서 테이블을 생성하면 기본적으로 제공되는 컬럼입니다.
    ROWID : ROW 고유의 아이디 (ROW를 수정해도 변하지 않음)
    ROWNUM : 행의 INDEX (ROW 삭제시 변경될 수 있다.)

ROWID - 해당 데이터의 저장위치를 가리키는 요소라고 할수 있습니다.
    오브젝트 번호 (6자리)
        해당 데이터가 속하는 오브젝트 번호다.
    상대 파일 번호 (3자리)
        테이블스페이스의 상대 파일번호를 의미하며, 각데이터별로 유일한 값을 가진다.
    블록 번호 (6자리)
        파일 안에 어느 블록인지를 의미한다.
    데이터 번호 (3자리)
        데이터 번호는 블록별로 데이터가 저장되어 있는 순서를 뜻한다.
*/

SELECT * 
FROM (
    SELECT ROWNUM AS rno, employee_id, first_name, last_name 
    FROM employees)
ORDER BY rno DESC
;
SELECT ROWID, ROWNUM, employee_id, first_name, last_name 
FROM employees;

-- ROW의 개수를 알고싶다면??
SELECT COUNT(*) FROM employees;
SELECT MAX(ROWNUM) FROM employees; -- 조금더 빠르다. (확실하지 않습니다 여러분들이 테스트 해보세요)
SELECT COUNT(ROWNUM) FROM employees;


