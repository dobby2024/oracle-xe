/*
���ϸ� :  Tune-Day10-IndexOperations.sql

�����ȹ �б�
    - ���̺� �׼��� ���μ����� �� ���̺��� �ε����� �׼����ϴ� ���μ��� �ϳ��� ����
    - ���� ���� �߿��� �鿩���Ⱑ ���� �Ǿ� �ִ� ������ ���� ����
    - �鿩���Ⱑ ����(�� ��������) ���� ���μ����� ����
    - �鿩���Ⱑ ���� ���� �����̶�� ���� �ִ�(���� ������) ������ ���� ����
    - ���� ��带 ���� ����� ��쿡�� ���� ��尡 ���� ����
*/

-- EXPLAIN PLAN
EXPLAIN PLAN FOR
SELECT d.dname, e.ename
FROM dept d, emp e
WHERE d.deptno = e.deptno
AND e.sal >= 3000
ORDER BY e.ename;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);    -- �����ȹ ���� �Դϴ�.

/*
DBMS_XPLAN.DISPLAY_CURSOR

�ʿ���� �ο�
GRANT SELECT ON V_$SESSION TO tuning;
GRANT SELECT ON V_$SQL_PLAN_STATISTICS_ALL TO tuning;
GRANT SELECT ON V_$SQL TO tuning;
GRANT SELECT ANY DICTIONARY TO tuning;

*/
-- ��� ĸ�ķ���
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
    ���� �ε����� ���ǵ� �÷��� ���������� '='�� �񱳵Ǵ� ���
    �� ���� ���� ���� INDEX RANGE SCAN�̹߻�
*/

SELECT * 
FROM products
WHERE prodno = 11000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
FULL TABLE SCAN
    ���̺� �Ҵ�� ù ��° ��Ϻ��� HWM �Ʒ��� ��� ����� ����
    1ȸ�� I/O�� ���ؼ� ���� ���� ����� ����
    
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
    INDEX UNIQUE SCAN�� ������ ��� INDEX SCAN�� INDEX RANGE SCAN �̴�.
    ���� �ε����� ���ǵ� �÷��� ���������� '='�񱳿����ڸ� ������ ��� �����ڷ� �񱳵Ǵ� ���
    ����� �ε����� ���ǵ� �÷��� �������� ����Ǵ� ���
*/
CREATE INDEX product_price_idx ON products(price);

SELECT * 
FROM products
WHERE price BETWEEN 3350 AND 4500;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
INDEX RANGE SCAN DESCENDING
    INDEX RANGE SCAN������ �������� ������ �˻� �� ��, �⺻������ �ּ� ��谪���� �˻��� �����Ͽ� 
    �ִ� ��谪���� �˻��� ����
    ����, �ִ� ��谪���� �˻��� �����Ͽ� �ּ� ��谪���� �˻��� �����ؾ��ϴ� ��쿡 ���
*/
CREATE INDEX product_price_idx ON products(price);

SELECT /*+ INDEX_DESC(products product_price_idx) */  * 
FROM products
WHERE price BETWEEN 3350 AND 4500;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/*
INDEX RANGE SCAN(MIN/MAX)
    �ռ� ����� �ִ밪 ã�⿡�� ������ ���� ����(����) �ε����� ����
*/
@clean;
CREATE INDEX products_idx ON products(psize, price);

SELECT /*+ INDEX(products products_idx) */ MAX(price)
FROM products
WHERE psize = 'XL'
;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



/*
INDEX �÷� ����!
    �ε����� ���ǵ� �÷��� �����ϸ� �ε����� Ȱ�� �� �� ����
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


-- ���� : 33561
SELECT /*+ FULL(orders) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 100;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

-- ���� : 957
SELECT /*+ INDEX(orders orders_custno_idx) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 100;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


-- ���� : 
SELECT /*+ FULL(orders) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

-- ���� : 
SELECT /*+ INDEX(orders orders_custno_idx) */ MAX(orderdate)
FROM orders
WHERE custno BETWEEN 1 AND 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));





















