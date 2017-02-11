DROP TABLE ADVERTISMENT_PAGES

--

DROP VIEW S_ADVERTISMENT_PAGES

--

DROP PROCEDURE I_ADVERTISMENT_PAGE

--

DROP PROCEDURE U_ADVERTISMENT_PAGE

--

DROP PROCEDURE D_ADVERTISMENT_PAGE

--

DROP TABLE ADVERTISMENTS

--

DROP VIEW S_ADVERTISMENTS

--

DROP PROCEDURE I_ADVERTISMENT

--

DROP PROCEDURE U_ADVERTISMENT

--

DROP PROCEDURE D_ADVERTISMENT

--

DROP TABLE PAGES

--

DROP VIEW S_PAGES

--

DROP PROCEDURE I_PAGE

--

DROP PROCEDURE U_PAGE

--

DROP PROCEDURE D_PAGE

--

/* �������� ������� ������� */

CREATE TABLE PAGES
(
  PAGE_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  ADDRESS VARCHAR(250) NOT NULL,
  PRIMARY KEY (PAGE_ID)
)

--

/* �������� ��������� ������� ������� */

CREATE VIEW S_PAGES
AS
SELECT * FROM PAGES

--

/* �������� ��������� ���������� �������� */

CREATE PROCEDURE I_PAGE
(
  IN PAGE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN ADDRESS VARCHAR(250)
)
BEGIN
  INSERT INTO PAGES (PAGE_ID,NAME,DESCRIPTION,ADDRESS)
       VALUES (PAGE_ID,NAME,DESCRIPTION,ADDRESS);
END;

--

/* �������� ��������� ��������� �������� */

CREATE PROCEDURE U_PAGE
(
  IN PAGE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN ADDRESS VARCHAR(250),
  IN OLD_PAGE_ID VARCHAR(32)
)
BEGIN
  UPDATE PAGES V
     SET V.PAGE_ID=PAGE_ID,
         V.NAME=NAME,
         V.DESCRIPTION=DESCRIPTION,
         V.ADDRESS=ADDRESS
   WHERE V.PAGE_ID=OLD_PAGE_ID;
END;

--

/* �������� ��������� �������� �������� */

CREATE PROCEDURE D_PAGE
(
  IN OLD_PAGE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM PAGES 
        WHERE PAGE_ID=OLD_PAGE_ID;
END;

--

CREATE TABLE BANNERS
(
  BANNER_ID VARCHAR(32) NOT NULL,
  ACCOUNT_ID VARCHAR(32),
  BANNER_TYPE INTEGER NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  VALUE LONGBLOB NOT NULL,
  LINK VARCHAR(250),
  PRIMARY KEY (BANNER_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS (ACCOUNT_ID)
)

--

CREATE VIEW S_BANNERS
AS
   SELECT B.*, 
          A.USER_NAME
     FROM BANNERS B
     LEFT JOIN ACCOUNTS A ON A.ACCOUNT_ID=B.ACCOUNT_ID

--

CREATE PROCEDURE I_BANNER
(
  IN BANNER_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN BANNER_TYPE INTEGER,
  IN VALUE LONGBLOB,
  IN LINK VARCHAR(250)
)
BEGIN
  INSERT INTO BANNERS (BANNER_ID,ACCOUNT_ID,NAME,DESCRIPTION,BANNER_TYPE,VALUE,LINK)
       VALUES (BANNER_ID,ACCOUNT_ID,NAME,DESCRIPTION,BANNER_TYPE,VALUE,LINK);
END;

--

CREATE PROCEDURE U_BANNER
(
  IN BANNER_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN BANNER_TYPE INTEGER,
  IN VALUE LONGBLOB,
  IN LINK VARCHAR(250),
  IN OLD_BANNER_ID VARCHAR(32)
)
BEGIN
  UPDATE BANNERS B
     SET B.BANNER_ID=BANNER_ID,
         B.ACCOUNT_ID=ACCOUNT_ID,
         B.NAME=NAME,
         B.DESCRIPTION=DESCRIPTION,
	 B.BANNER_TYPE=BANNER_TYPE,
	 B.VALUE=VALUE,
	 B.LINK=LINK
   WHERE B.BANNER_ID=OLD_BANNER_ID;
END;

--

CREATE PROCEDURE D_BANNER
(
  IN OLD_BANNER_ID VARCHAR(32)
)
BEGIN
  DELETE FROM BANNERS
        WHERE BANNER_ID=OLD_BANNER_ID;
END;

--

CREATE TABLE PLACEMENTS
(
  PLACEMENT_ID VARCHAR(32) NOT NULL,
  BANNER_ID VARCHAR(32) NOT NULL,
  PAGE_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32),
  WHO_PLACED VARCHAR(32) NOT NULL,
  DATE_PLACED DATETIME NOT NULL,
  PLACE VARCHAR(10) NOT NULL,
  DATE_BEGIN DATE NOT NULL,
  DATE_END DATE,
  PRIORITY INTEGER NOT NULL,
  COUNTER INTEGER,
  PRIMARY KEY (PLACEMENT_ID),
  FOREIGN KEY (BANNER_ID) REFERENCES BANNERS (BANNER_ID),
  FOREIGN KEY (PAGE_ID) REFERENCES PAGES (PAGE_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (WHO_PLACED) REFERENCES ACCOUNTS (ACCOUNT_ID)
)

--

CREATE VIEW S_PLACEMENTS
AS
SELECT P.*,
       B.NAME AS BANNER_NAME,
       PG.NAME AS PAGE_NAME,
       AC1.USER_NAME, 
       AC2.USER_NAME AS WHO_PLACED_NAME 
  FROM PLACEMENTS P
  JOIN BANNERS B ON B.BANNER_ID=P.BANNER_ID
  JOIN ACCOUNTS AC2 ON AC2.ACCOUNT_ID=P.WHO_PLACED
  LEFT JOIN PAGES PG ON PG.PAGE_ID=P.PAGE_ID
  LEFT JOIN ACCOUNTS AC1 ON AC1.ACCOUNT_ID=P.ACCOUNT_ID

--

CREATE PROCEDURE I_PLACEMENT
(
  IN PLACEMENT_ID VARCHAR(32),
  IN BANNER_ID VARCHAR(32),
  IN PAGE_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN WHO_PLACED VARCHAR(32),
  IN DATE_PLACED DATETIME,
  IN PLACE VARCHAR(10),
  IN DATE_BEGIN DATE,
  IN DATE_END DATE,
  IN PRIORITY INTEGER,
  IN COUNTER INTEGER
)
BEGIN
  INSERT INTO PLACEMENTS (PLACEMENT_ID,BANNER_ID,PAGE_ID,ACCOUNT_ID,WHO_PLACED,
                          DATE_PLACED,PLACE,DATE_BEGIN,DATE_END,PRIORITY,COUNTER)
       VALUES (PLACEMENT_ID,BANNER_ID,PAGE_ID,ACCOUNT_ID,WHO_PLACED,
               DATE_PLACED,PLACE,DATE_BEGIN,DATE_END,PRIORITY,COUNTER);
END;

--

CREATE PROCEDURE U_PLACEMENT
(
  IN PLACEMENT_ID VARCHAR(32),
  IN BANNER_ID VARCHAR(32),
  IN PAGE_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN WHO_PLACED VARCHAR(32),
  IN DATE_PLACED DATETIME,
  IN PLACE VARCHAR(10),
  IN DATE_BEGIN DATE,
  IN DATE_END DATE,
  IN PRIORITY INTEGER,
  IN COUNTER INTEGER,
  IN OLD_PLACEMENT_ID VARCHAR(32)
)
BEGIN
  UPDATE PLACEMENTS P
     SET P.PLACEMENT_ID=PLACEMENT_ID,
         P.BANNER_ID=BANNER_ID,
         P.PAGE_ID=PAGE_ID,
         P.ACCOUNT_ID=ACCOUNT_ID,
         P.WHO_PLACED=WHO_PLACED,
         P.DATE_PLACED=DATE_PLACED,
         P.PLACE=PLACE,
         P.DATE_BEGIN=DATE_BEGIN,
         P.DATE_END=DATE_END,
         P.PRIORITY=PRIORITY,
         P.COUNTER=COUNTER
   WHERE P.PLACEMENT_ID=OLD_PLACEMENT_ID;
END;

--

CREATE PROCEDURE D_PLACEMENT
(
	IN OLD_PLACEMENT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM PLACEMENTS
        WHERE PLACEMENT_ID=OLD_PLACEMENT_ID;
END;

--
