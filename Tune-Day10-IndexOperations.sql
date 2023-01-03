/*
파일명 :  Tune-Day10-IndexOperations.sql

실행계획 읽기
    - 테이블 액세스 프로세스와 그 테이블의 인덱스를 액세스하는 프로세스 하나의 단위
    - 여러 문장 중에서 들여쓰기가 많이 되어 있는 문장이 먼저 실행
    - 들여쓰기가 적은(한 레벨위의) 상위 프로세스에 종속
    - 들여쓰기가 같은 동일 레벨이라면 위에 있는(먼저 나오는) 문장이 먼저 실행
    - 하위 노드를 가진 노드의 경우에는 하위 노드가 먼저 실행
*/

-- EXPLAIN PLAN
EXPLAIN PLAN FOR
SELECT d.dname, e.ename
FROM dept d, emp e
WHERE d.deptno = e.deptno
AND e.sal >= 3000
ORDER BY e.ename;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);    -- 실행계획 예측 입니다.

/*
DBMS_XPLAN.DISPLAY_CURSOR

필요권한 부여
GRANT SELECT ON V_$SESSION TO tuning;
GRANT SELECT ON V_$SQL_PLAN_STATISTICS_ALL TO tuning;
GRANT SELECT ON V_$SQL TO tuning;
GRANT SELECT ANY DICTIONARY TO tuning;

*/
-- 통계 캡쳐레벨
ALTER SYSTEM SET STATISTICS_LEVEL = ALL;

SELECT d.dname, e.ename
FROM dept d, emp e
WHERE d.deptno = e.deptno
AND e.sal >= 3000
ORDER BY e.ename;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

CREATE INDEX emp_sal_idx ON emp(sal);


/*
INDEX UNIQUE SCAN 
    고유 인덱스가 정의된 컬럼이 조건절에서 '='로 비교되는 경우
    그 외의 경우는 전부 INDEX RANGE SCAN이발생
*/

SELECT * 
FROM products
WHERE prodno = 11000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
FULL TABLE SCAN
    테이블에 할당된 첫 번째 블록부터 HWM 아래의 모든 블록을 읽음
    1회의 I/O에 대해서 여러 개의 블록을 읽음
    
    SHOW PARAMETER DB_FILE_MULTIBLOCK_READ_COUNT;
*/
SELECT /*+ FULL(p) */ * 
FROM products p
WHERE prodno = 11000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

SELECT * FROM orderdetails;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));
              


/*
INDEX RANGE SCAN
    INDEX UNIQUE SCAN을 제외한 모든 INDEX SCAN을 INDEX RANGE SCAN 이다.
    고유 인덱스가 정의된 컬럼이 조건절에서 '='비교연산자를 제외한 모든 연산자로 비교되는 경우
    비고유 인덱스가 정의된 컬럼이 조건절에 기술되는 경우
*/
CREATE INDEX product_price_idx ON products(price);

SELECT * 
FROM products
WHERE price BETWEEN 3350 AND 4500;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
INDEX RANGE SCAN DESCENDING
    INDEX RANGE SCAN에서는 조건절의 범위를 검색 할 때, 기본적으로 최소 경계값부터 검색을 시작하여 
    최대 경계값에서 검색을 종료
    만약, 최대 경계값에서 검색을 시작하여 최소 경계값에서 검색을 종료해야하는 경우에 사용
*/
CREATE INDEX product_price_idx ON products(price);

SELECT /*+ INDEX_DESC(products product_price_idx) */  * 
FROM products
WHERE price BETWEEN 3350 AND 4500;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
INDEX RANGE SCAN(MIN/MAX)
    앞서 언급한 최대값 찾기에서 다음과 같이 결합(복합) 인덱스를 정의
*/
@clean;
CREATE INDEX products_idx ON products(psize, price);

SELECT /*+ INDEX(products products_idx) */ MAX(price)
FROM products
WHERE psize = 'XL'
;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



/*
INDEX 컬럼 가공!
    인덱스가 정의된 컬럼을 가공하면 인덱스를 활용 할 수 없음
*/
@clean;

CREATE INDEX products_price_idx on products(price);
SELECT /*+ INDEX(products_price_idx) */ *
FROM products
WHERE TRUNC(price) BETWEEN 3350 AND 4500;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
*/
-- 100000
SELECT COUNT(*) FROM orders;
@clean;

CREATE INDEX orders_custno_idx ON orders(custno);


-- 버퍼 : 33561
SELECT /*+ FULL(orders) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 100;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

-- 버퍼 : 957
SELECT /*+ INDEX(orders orders_custno_idx) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 100;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


-- 버퍼 : 
SELECT /*+ FULL(orders) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

-- 버퍼 : 
SELECT /*+ INDEX(orders orders_custno_idx) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));





















