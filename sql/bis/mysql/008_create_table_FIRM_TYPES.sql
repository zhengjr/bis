/* �������� ������� ����� ���� */

CREATE TABLE /*PREFIX*/FIRM_TYPES
(
  FIRM_TYPE_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER NOT NULL,
  PRIMARY KEY (FIRM_TYPE_ID)
)

--

/* �������� ��������� ������� ����� ���� */

CREATE VIEW /*PREFIX*/S_FIRM_TYPES
AS
SELECT * FROM /*PREFIX*/FIRM_TYPES

--

/* �������� ��������� ���������� ���� ����� */

CREATE PROCEDURE /*PREFIX*/I_FIRM_TYPE
(
  IN FIRM_TYPE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/FIRM_TYPES (FIRM_TYPE_ID,NAME,DESCRIPTION,PRIORITY)
       VALUES (FIRM_TYPE_ID,NAME,DESCRIPTION,PRIORITY);
END;

--

/* �������� ��������� ��������� ���� ����� */

CREATE PROCEDURE /*PREFIX*/U_FIRM_TYPE
(
  IN FIRM_TYPE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
  IN OLD_FIRM_TYPE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/FIRM_TYPES V
     SET V.FIRM_TYPE_ID=FIRM_TYPE_ID,
         V.NAME=NAME,
	       V.DESCRIPTION=DESCRIPTION,
				 V.PRIORITY=PRIORITY
   WHERE V.FIRM_TYPE_ID=OLD_FIRM_TYPE_ID;
END;

--

/* �������� ��������� �������� ���� ����� */

CREATE PROCEDURE /*PREFIX*/D_FIRM_TYPE
(
  IN OLD_FIRM_TYPE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/FIRM_TYPES 
        WHERE FIRM_TYPE_ID=OLD_FIRM_TYPE_ID;
END;

--