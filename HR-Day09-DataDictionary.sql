/*
���ϸ� : HR-Day09-DataDictionary.sql

������ ��ųʸ�
    ����Ŭ ������ ��ųʸ��� �����ͺ��̽��� ���� ��Ÿ �������̸�
    ��� ��ü�� �̸��� �Ӽ��� �����մϴ�.
*/

SELECT * FROM dictionary;

/*
DBA_ : DBA ���� QUERY ����/ ����׸� / DBA����
ALL_ : ��� QEURY ���� / ������ ���� ��ü�� �������� ���� ������ �ο��� ��Ÿ ��ü
USER_ : ������ �����ϴ� ����׸� / ������ OWNER ���� �����ϰ� �Ϲ������� ALL_ �� ����.
*/

SELECT table_name, tablespace_name 
FROM all_tables;

SELECT *
FROM all_tables;

-- ��Ű���� ������ �ش� ���̺�
SELECT table_name, tablespace_name
FROM user_tables;

-- ������ ����
SELECT sequence_name, min_value, max_value,
        increment_by
FROM all_sequences;

-- �α��� �� �� �ִ� ����
SELECT username, account_status
FROM dba_users
WHERE account_status = 'OPEN'
;

-- �ε��� ������ ���� �ִ� ��
DESC dba_indexes;

/*
���ɺ�(Dynamic Performance View)
    ����Ŭ instance�� �۾� �� ���ɿ� ���� ����͸�, ���� ���� ���� ���Դϴ�.

v$instance
    �ش� �ν��Ͻ� ���� ���(sid, �ν��Ͻ� ���� ���� ��)
v$session
    ����� ���� ���� ���
v$sysstat
    �ڿ���� ���� ���
v$process
    ���μ��� ���� ���
v$lock
    �� ��û, ���� ������ �����ش�.
v$event_name
    ������� �̺�Ʈ���� ������ �����ش�.
v$open_cursor
    ����� ������ Ŀ���� �����ش�.
v$system_parameter
    ����Ŭ �Ķ���� �������� �����ش�. �ð� ���� ����Ǯ���� ������ ���� �ִ�.
v$parameter
    ���� ����Ŭ �Ķ���� ������ ���������� ���ݴ� �����ϰ� �����ش�.
v$option
    ����Ŭ �߰���� �� ��Ÿ �ɼǰ� ������ �����ش�.
*/

-- CPU �ð��� 200,000 ����ũ���� �̻� �Һ�Ǵ� SQL��
SELECT sql_text, executions 
FROM v$sql
WHERE cpu_time > 20000;

-- ���� ��ǻ�Ϳ��� �α����� ���缼���� ������Դϱ�?
SELECT * FROM v$session
WHERE 1=1
AND machine = 'DESKTOP-Q2FMHK6'
AND logon_time > SYSDATE - 1;

-- ���� �ٸ������� �������� Lock�� �����ϰ� �ִ� ������ ����ID �����̸�
-- Lock ���°� �󸶵��� �����ǰ� �ֽ��ϱ�? (ȭ����)
SELECT 
    a.sid,             -- SID
    b.serial#,         -- �ø���
    a.ctime            -- �����㰡�� ���ĺ��� ����ð�
FROM v$lock a,
    v$session b
WHERE 1=1
AND a.sid = b.sid
AND block > 0;

desc v$session;
select * FROM v$session;

-- �Ǽ����� ��ȸ
SELECT 
    a.sid,          -- SID
    a.serial#,      -- �ø����ȣ
    a.process,      -- ���μ�������
    a.username,     -- ����
    a.osuser,       -- �������� OS ����� ����
    b.sql_text,     -- sql
    c.program       -- ���� ���α׷�
FROM 
    v$session a,
    v$sqlarea b,
    v$process c
WHERE 1=1
    AND a.sql_hash_value = b.hash_value
    AND a.sql_address = b.address
    AND a.paddr = c.addr
    AND a.status = 'ACTIVE';
    
-- ���� ���� KILL
ALTER SYSTEM KILL SESSION 'SID, �ø����ȣ';

ALTER SYSTEM KILL SESSION '259, 60160';


