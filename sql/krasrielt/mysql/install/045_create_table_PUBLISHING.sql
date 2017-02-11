/* �������� ������� ������� */

CREATE TABLE /*PREFIX*/PUBLISHING
(
  PUBLISHING_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER NOT NULL,
  PRIMARY KEY (PUBLISHING_ID)
)

--

/* �������� ��������� ������� ������� */

CREATE VIEW /*PREFIX*/S_PUBLISHING
AS
SELECT * FROM /*PREFIX*/PUBLISHING

--

/* �������� ��������� ���������� ������� */

CREATE PROCEDURE /*PREFIX*/I_PUBLISHING
(
  IN PUBLISHING_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/PUBLISHING (PUBLISHING_ID,NAME,DESCRIPTION,PRIORITY)
       VALUES (PUBLISHING_ID,NAME,DESCRIPTION,PRIORITY);
END;

--

/* �������� ��������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/U_PUBLISHING
(
  IN PUBLISHING_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
  IN OLD_PUBLISHING_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PUBLISHING V
     SET V.PUBLISHING_ID=PUBLISHING_ID,
         V.NAME=NAME,
	       V.DESCRIPTION=DESCRIPTION,
				 V.PRIORITY=PRIORITY
   WHERE V.PUBLISHING_ID=OLD_PUBLISHING_ID;
END;

--

/* �������� ��������� �������� ������� */

CREATE PROCEDURE /*PREFIX*/D_PUBLISHING
(
  IN OLD_PUBLISHING_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PUBLISHING 
        WHERE PUBLISHING_ID=OLD_PUBLISHING_ID;
END;

--