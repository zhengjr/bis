/* �������� ������� ������������ ������� */

CREATE TABLE /*PREFIX*/COLUMN_PARAMS
(
  COLUMN_ID VARCHAR(32) NOT NULL,
  PARAM_ID VARCHAR(32) NOT NULL,
  PRIORITY INTEGER NOT NULL,
  STRING_BEFORE VARCHAR(100),
  STRING_AFTER VARCHAR(100),
  USE_STRING_BEFORE INTEGER NOT NULL,
  USE_STRING_AFTER INTEGER NOT NULL,
  ELEMENT_TYPE INTEGER
  PRIMARY KEY (COLUMN_ID,PARAM_ID),
  FOREIGN KEY (COLUMN_ID) REFERENCES COLUMNS (COLUMN_ID),
  FOREIGN KEY (PARAM_ID) REFERENCES PARAMS (PARAM_ID)
)

--

/* �������� ��������� ������� ������������ ������� */

CREATE VIEW /*PREFIX*/S_COLUMN_PARAMS
AS
SELECT CP.*,
			 C.NAME AS COLUMN_NAME,
			 P.NAME AS PARAM_NAME,
			 P.PARAM_TYPE 
  FROM /*PREFIX*/COLUMN_PARAMS CP
	JOIN /*PREFIX*/COLUMNS C ON  C.COLUMN_ID=CP.COLUMN_ID
  JOIN /*PREFIX*/PARAMS P ON P.PARAM_ID=CP.PARAM_ID
	
--

/* �������� ��������� ���������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/I_COLUMN_PARAM
(
  IN COLUMN_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN STRING_BEFORE VARCHAR(100),
	IN USE_STRING_BEFORE INTEGER,
	IN STRING_AFTER VARCHAR(100),
	IN USE_STRING_AFTER INTEGER,
  IN ELEMENT_TYPE INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/COLUMN_PARAMS (COLUMN_ID,PARAM_ID,PRIORITY,STRING_BEFORE,USE_STRING_BEFORE,
	                                     STRING_AFTER,USE_STRING_AFTER,ELEMENT_TYPE)
       VALUES (COLUMN_ID,PARAM_ID,PRIORITY,STRING_BEFORE,USE_STRING_BEFORE,
			         STRING_AFTER,USE_STRING_AFTER,ELEMENT_TYPE);
END;

--

/* �������� ��������� ��������� ��������� � ������� */

CREATE PROCEDURE /*PREFIX*/U_COLUMN_PARAM
(
  IN COLUMN_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN STRING_BEFORE VARCHAR(100),
	IN USE_STRING_BEFORE INTEGER,
	IN STRING_AFTER VARCHAR(100),
	IN USE_STRING_AFTER INTEGER,
  IN ELEMENT_TYPE INTEGER,
  IN OLD_COLUMN_ID VARCHAR(32),
  IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/COLUMN_PARAMS CP
     SET CP.COLUMN_ID=COLUMN_ID,
		     CP.PARAM_ID=PARAM_ID,
         CP.PRIORITY=PRIORITY,
         CP.STRING_BEFORE=STRING_BEFORE,
				 CP.USE_STRING_BEFORE=USE_STRING_BEFORE,
         CP.STRING_AFTER=STRING_AFTER,
				 CP.USE_STRING_AFTER=USE_STRING_AFTER,
         CP.ELEMENT_TYPE=ELEMENT_TYPE
   WHERE CP.COLUMN_ID=OLD_COLUMN_ID
	   AND CP.PARAM_ID=OLD_PARAM_ID;
END;

--

/* �������� ��������� �������� ��������� � ������� */

CREATE PROCEDURE /*PREFIX*/D_COLUMN_PARAM
(
  IN OLD_COLUMN_ID VARCHAR(32),
	IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/COLUMN_PARAMS 
        WHERE COLUMN_ID=OLD_COLUMN_ID
				  AND PARAM_ID=OLD_PARAM_ID;
END;

--