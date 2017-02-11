/* �������� ������� ���� */

CREATE TABLE /*PREFIX*/STREETS
(
  STREET_ID VARCHAR(32) NOT NULL,
  LOCALITY_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  PREFIX VARCHAR(10),
  PRIMARY KEY (STREET_ID),
  FOREIGN KEY (LOCALITY_ID) REFERENCES LOCALITIES (LOCALITY_ID)
)

--

/* �������� ��������� ���� */

CREATE VIEW /*PREFIX*/S_STREETS
AS
SELECT S.*,
       L.NAME AS LOCALITY_NAME,
       L.PREFIX AS LOCALITY_PREFIX
  FROM /*PREFIX*/STREETS S
  JOIN /*PREFIX*/LOCALITIES L ON L.LOCALITY_ID=S.LOCALITY_ID

--

/* �������� ��������� ���������� ����� */

CREATE PROCEDURE /*PREFIX*/I_STREET
(
  IN STREET_ID VARCHAR(32),
  IN LOCALITY_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN PREFIX VARCHAR(10)
)
BEGIN
  INSERT INTO /*PREFIX*/STREETS (STREET_ID,LOCALITY_ID,NAME,PREFIX)
       VALUES (STREET_ID,LOCALITY_ID,NAME,PREFIX);
END;

--

/* �������� ��������� ��������� ����� */

CREATE PROCEDURE /*PREFIX*/U_STREET
(
  IN STREET_ID VARCHAR(32),
  IN LOCALITY_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN PREFIX VARCHAR(10),
  IN OLD_STREET_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/STREETS S
     SET S.STREET_ID=STREET_ID,
         S.LOCALITY_ID=LOCALITY_ID,
         S.NAME=NAME,
         S.PREFIX=PREFIX
   WHERE S.STREET_ID=OLD_STREET_ID;
END;

--

/* �������� ��������� �������� ����� */

CREATE PROCEDURE /*PREFIX*/D_STREET
(
  IN OLD_STREET_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/STREETS 
        WHERE STREET_ID=OLD_STREET_ID;
END;

--