/* �������� ������� ����� ������������ */

CREATE TABLE /*PREFIX*/ACCOUNT_ROLES
(
  ROLE_ID VARCHAR2(32) NOT NULL,
  ACCOUNT_ID VARCHAR2(32) NOT NULL,
  PRIMARY KEY (ROLE_ID,ACCOUNT_ID),
  FOREIGN KEY (ROLE_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID)
)

--

/* �������� ��������� ������� ����� ������������ */

CREATE VIEW /*PREFIX*/S_ACCOUNT_ROLES
AS
SELECT AP.*,
       R.USER_NAME AS ROLE_NAME,
  	   A.USER_NAME AS USER_NAME
  FROM /*PREFIX*/ACCOUNT_ROLES AP
  JOIN /*PREFIX*/ACCOUNTS R ON R.ACCOUNT_ID=AP.ROLE_ID
  JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=AP.ACCOUNT_ID
			
--

/* �������� ��������� ���������� ���� ������������ */

CREATE OR REPLACE PROCEDURE /*PREFIX*/I_ACCOUNT_ROLE
(
  ROLE_ID IN VARCHAR2,
  ACCOUNT_ID IN VARCHAR2
)
AS
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNT_ROLES (ROLE_ID,ACCOUNT_ID)
       VALUES (ROLE_ID,ACCOUNT_ID);
END;

--

/* �������� ��������� ��������� ���� � ������������ */

CREATE OR REPLACE PROCEDURE /*PREFIX*/U_ACCOUNT_ROLE
(
  ROLE_ID IN VARCHAR2,
  ACCOUNT_ID IN VARCHAR2,
  OLD_ROLE_ID IN VARCHAR2,
  OLD_ACCOUNT_ID IN VARCHAR2
)
AS
BEGIN
  UPDATE /*PREFIX*/ACCOUNT_ROLES
     SET ROLE_ID=U_ACCOUNT_ROLE.ROLE_ID,
         ACCOUNT_ID=U_ACCOUNT_ROLE.ACCOUNT_ID
   WHERE ROLE_ID=OLD_ROLE_ID
     AND ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� �������� ���� � ������������ */

CREATE OR REPLACE PROCEDURE /*PREFIX*/D_ACCOUNT_ROLE
(
  OLD_ROLE_ID IN VARCHAR2,
  OLD_ACCOUNT_ID IN VARCHAR2
)
AS
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNT_ROLES 
        WHERE ROLE_ID=OLD_ROLE_ID
		  AND ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� */

COMMIT