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



