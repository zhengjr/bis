/* �������� ������� ���������� */

CREATE TABLE /*PREFIX*/LOCKS
(
  LOCK_ID VARCHAR(32) NOT NULL,
  APPLICATION_ID VARCHAR(32) NOT NULL,
  ACCOUNT_ID VARCHAR(32),
  DATE_BEGIN TIMESTAMP NOT NULL,
  DATE_END TIMESTAMP,
  METHOD VARCHAR(100),
  OBJECT VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  IP_LIST VARCHAR(1000),
  PRIMARY KEY (LOCK_ID),
  FOREIGN KEY (APPLICATION_ID) REFERENCES /*PREFIX*/APPLICATIONS (APPLICATION_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID)
)

--


/* �������� ��������� ������� ���������� */

CREATE VIEW /*PREFIX*/S_LOCKS
AS
  SELECT L.*,
         A.NAME AS APPLICATION_NAME,
         AC.USER_NAME
    FROM /*PREFIX*/LOCKS L
    JOIN /*PREFIX*/APPLICATIONS A ON A.APPLICATION_ID=L.APPLICATION_ID
    LEFT JOIN /*PREFIX*/ACCOUNTS AC ON AC.ACCOUNT_ID=L.ACCOUNT_ID


--


/* �������� ��������� ���������� ���������� */

CREATE PROCEDURE /*PREFIX*/I_LOCK
(
  IN LOCK_ID VARCHAR(32),
  IN APPLICATION_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN DATE_BEGIN TIMESTAMP,
  IN DATE_END TIMESTAMP,
  IN METHOD VARCHAR(100),
  IN OBJECT VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN IP_LIST VARCHAR(1000)
)
BEGIN
  INSERT INTO /*PREFIX*/LOCKS (LOCK_ID,APPLICATION_ID,ACCOUNT_ID,DATE_BEGIN,DATE_END,METHOD,OBJECT,DESCRIPTION,IP_LIST)
       VALUES (LOCK_ID,APPLICATION_ID,ACCOUNT_ID,DATE_BEGIN,DATE_END,METHOD,OBJECT,DESCRIPTION,IP_LIST);
END;

--

/* �������� ��������� ��������� ���������� */

CREATE PROCEDURE /*PREFIX*/U_LOCK
(
  IN LOCK_ID VARCHAR(32),
  IN APPLICATION_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN DATE_BEGIN TIMESTAMP,
  IN DATE_END TIMESTAMP,
  IN METHOD VARCHAR(100),
  IN OBJECT VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN IP_LIST VARCHAR(1000),
  IN OLD_LOCK_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/LOCKS L
     SET L.LOCK_ID=LOCK_ID,
         L.APPLICATION_ID=APPLICATION_ID,
         L.ACCOUNT_ID=ACCOUNT_ID,
         L.DATE_BEGIN=DATE_BEGIN,
         L.DATE_END=DATE_END,
         L.METHOD=METHOD,
         L.OBJECT=OBJECT,
         L.DESCRIPTION=DESCRIPTION,
         L.IP_LIST=IP_LIST
   WHERE L.LOCK_ID=OLD_LOCK_ID;
END;


--

/* �������� ��������� �������� ���������� */

CREATE PROCEDURE /*PREFIX*/D_LOCK
(
  IN OLD_LOCK_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/LOCKS
        WHERE LOCK_ID=OLD_LOCK_ID;
END;

--

/* �������� ������� ������������ �������� */

CREATE TABLE /*PREFIX*/SCRIPTS
(
  SCRIPT_ID VARCHAR(32) NOT NULL,
  ENGINE VARCHAR(100) NOT NULL,
  SCRIPT LONGBLOB NOT NULL,
  PLACE INTEGER NOT NULL,
  PRIMARY KEY (SCRIPT_ID),
  FOREIGN KEY (SCRIPT_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ������������ �������� */

CREATE VIEW /*PREFIX*/S_SCRIPTS
AS
  SELECT R.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/SCRIPTS R
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=R.SCRIPT_ID

--

/* �������� ��������� ���������� ������������� �������� */

CREATE PROCEDURE /*PREFIX*/I_SCRIPT
(
  IN SCRIPT_ID VARCHAR(32),
  IN ENGINE VARCHAR(100),
  IN SCRIPT LONGBLOB,
  IN PLACE INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/SCRIPTS (SCRIPT_ID,ENGINE,SCRIPT,PLACE)
       VALUES (SCRIPT_ID,ENGINE,SCRIPT,PLACE);
END;

--

/* �������� ��������� ��������� ������������� ������� */

CREATE PROCEDURE /*PREFIX*/U_SCRIPT
(
  IN SCRIPT_ID VARCHAR(32),
  IN ENGINE VARCHAR(100),
  IN SCRIPT LONGBLOB,
  IN PLACE INTEGER,
  IN OLD_SCRIPT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/SCRIPTS S
     SET S.SCRIPT_ID=SCRIPT_ID,
         S.ENGINE=ENGINE,
         S.SCRIPT=SCRIPT,
         S.PLACE=PLACE
   WHERE S.SCRIPT_ID=OLD_SCRIPT_ID;
END;

--

/* �������� ��������� �������� ������������� ������� */

CREATE PROCEDURE /*PREFIX*/D_SCRIPT
(
  IN OLD_SCRIPT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/SCRIPTS
        WHERE SCRIPT_ID=OLD_SCRIPT_ID;
END;

--

/* �������� ��������� ���������� ������������� */

DROP PROCEDURE /*PREFIX*/R_PRESENTATION

--

/* �������� ��������� ���������� ������������� */

CREATE PROCEDURE /*PREFIX*/R_PRESENTATION
(
  IN PRESENTATION_ID VARCHAR(32)
)
BEGIN
  DECLARE ATABLE VARCHAR(100);
	DECLARE COLUMN_ID VARCHAR(32);
	DECLARE PUBLISHING_ID VARCHAR(32);
	DECLARE VIEW_ID VARCHAR(32);
	DECLARE TYPE_ID VARCHAR(32);
	DECLARE OPERATION_ID VARCHAR(32);
	DECLARE CONDITIONS LONGBLOB;
	DECLARE SORTING VARCHAR(250);
	DECLARE PARAM_IDS VARCHAR(1000);
	DECLARE COLUMN_NAME VARCHAR(100);
	DECLARE OLD_COLUMN_ID VARCHAR(32);
	DECLARE PARAM_ID VARCHAR(32);
	DECLARE PARAM_TYPE INTEGER;
	DECLARE PARAM_COUNT INTEGER;
	DECLARE PRESENTATION_TYPE INTEGER;
	DECLARE REAL_COUNT INTEGER;
	DECLARE CP_STRING_BEFORE VARCHAR(100);
	DECLARE CP_STRING_AFTER VARCHAR(100);
	DECLARE CP_USE_STRING_BEFORE INTEGER;
	DECLARE CP_USE_STRING_AFTER INTEGER;
	DECLARE FIELD_NAME VARCHAR(1000);
	DECLARE SELECT_NAME VARCHAR(200);
	DECLARE NEW_QUERY VARCHAR(2000);
	DECLARE DONE INTEGER DEFAULT 0;
	DECLARE C1 CURSOR FOR SELECT PC.COLUMN_ID, C.NAME, CP.PARAM_ID, P.PARAM_TYPE,
	                             CP.STRING_BEFORE AS CP_STRING_BEFORE,CP.STRING_AFTER AS CP_STRING_AFTER,
															 CP.USE_STRING_BEFORE AS CP_USE_STRING_BEFORE,CP.USE_STRING_AFTER AS CP_USE_STRING_AFTER,
															 PR.PUBLISHING_ID,PR.VIEW_ID,PR.TYPE_ID,PR.OPERATION_ID,PR.CONDITIONS,PR.SORTING,
															 PR.PRESENTATION_TYPE,
															 (SELECT COUNT(*) FROM /*PREFIX*/COLUMN_PARAMS CP1 WHERE CP1.COLUMN_ID=CP.COLUMN_ID) AS PARAM_COUNT
  												FROM /*PREFIX*/PRESENTATION_COLUMNS PC
  												JOIN /*PREFIX*/COLUMNS C ON C.COLUMN_ID=PC.COLUMN_ID
  												JOIN /*PREFIX*/COLUMN_PARAMS CP ON CP.COLUMN_ID=C.COLUMN_ID
  												JOIN /*PREFIX*/PARAMS P ON P.PARAM_ID=CP.PARAM_ID
													JOIN /*PREFIX*/PRESENTATIONS PR ON PR.PRESENTATION_ID=PC.PRESENTATION_ID
 												 WHERE PC.PRESENTATION_ID=PRESENTATION_ID
                         ORDER BY PC.PRIORITY, CP.PRIORITY;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE=1;												
	
  SELECT P.TABLE_NAME INTO ATABLE
    FROM /*PREFIX*/PRESENTATIONS P
   WHERE P.PRESENTATION_ID=PRESENTATION_ID
	   AND P.PRESENTATION_TYPE IN (0);
	
	IF (ATABLE<>'') THEN
	
		SET @QUERY=CONCAT('DROP TABLE IF EXISTS /*PREFIX*/',ATABLE);
    PREPARE STMT FROM @QUERY;
    EXECUTE STMT;
    DEALLOCATE PREPARE STMT;

	  SET @QUERY=CONCAT('CREATE TABLE /*PREFIX*/',ATABLE,' AS SELECT T.* FROM (SELECT OP.OBJECT_ID,PO.PUBLISHING_ID,P.NAME AS PUBLISHING_NAME,');
	  SET @QUERY=CONCAT(@QUERY,'O.VIEW_ID,V.NAME AS VIEW_NAME,O.TYPE_ID,T.NAME AS TYPE_NAME,O.OPERATION_ID,OT.NAME AS OPERATION_NAME,');
	  SET @QUERY=CONCAT(@QUERY,'PO.DATE_BEGIN,O.ACCOUNT_ID,A.USER_NAME,A.PHONE,O.STATUS');
	  SET PARAM_IDS='';
	  SET OLD_COLUMN_ID='';
	  SET FIELD_NAME='';
	  SET REAL_COUNT=0;
		
	  OPEN C1;
    FETCH C1 INTO COLUMN_ID,COLUMN_NAME,PARAM_ID,PARAM_TYPE,
		              CP_STRING_BEFORE,CP_STRING_AFTER,CP_USE_STRING_BEFORE,CP_USE_STRING_AFTER,
		              PUBLISHING_ID,VIEW_ID,TYPE_ID,OPERATION_ID,CONDITIONS,SORTING,PRESENTATION_TYPE,PARAM_COUNT;
    WHILE NOT DONE DO
	
		  IF (OLD_COLUMN_ID<>COLUMN_ID) THEN
  		  SET REAL_COUNT=0;
	  	END IF;
		
		  SET REAL_COUNT=REAL_COUNT+1;
		
	  /*CASE 
 	    WHEN PARAM_TYPE=0 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE USING cp1251),NULL))');
      WHEN PARAM_TYPE=2 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE,SIGNED),NULL))');
      WHEN PARAM_TYPE=3 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE,DECIMAL(15,2)),NULL))');
	    ELSE SET NEW_QUERY='';
    END CASE;*/
		
		  SET SELECT_NAME='CONVERT(OP.VALUE USING cp1251)'; 
		  IF (PRESENTATION_TYPE IN (2,3)) AND (PARAM_TYPE=0) THEN
			  SET SELECT_NAME='IFNULL((SELECT EXPORT FROM /*PREFIX*/PARAM_VALUES WHERE NAME=OP.VALUE AND PARAM_ID=OP.PARAM_ID LIMIT 0,1),CONVERT(OP.VALUE USING cp1251))';
			END IF;
			
		  SET FIELD_NAME=CONCAT('IFNULL(MIN(IF(OP.PARAM_ID=''',
		                        PARAM_ID,
				  									''',CONCAT(''',
					  								IFNULL(CP_STRING_BEFORE,''),
						  							''',',
														SELECT_NAME,
														',''',
							  						IFNULL(CP_STRING_AFTER,''),
								  					'''),NULL)),CONCAT(''',
														IF(CP_USE_STRING_BEFORE=1,IFNULL(CP_STRING_BEFORE,''),''),
														''',''',
														IF(CP_USE_STRING_AFTER=1,IFNULL(CP_STRING_AFTER,''),''),
														'''))');
		
		  IF (REAL_COUNT=PARAM_COUNT) THEN
    		IF (PARAM_COUNT=1) THEN
	    	  SET NEW_QUERY=FIELD_NAME;
 		    ELSE	
  		      SET NEW_QUERY=CONCAT(NEW_QUERY,',',FIELD_NAME,')');
	  	    END IF;
		    SET @QUERY=CONCAT(@QUERY,',CAST(',NEW_QUERY,' AS CHAR(250)) AS ''',COLUMN_NAME,'''');
  			SET NEW_QUERY='';
		  ELSE
		    IF (REAL_COUNT=1) THEN
			    SET NEW_QUERY=CONCAT('CONCAT(',FIELD_NAME);
			  ELSE	
  			  SET NEW_QUERY=CONCAT(NEW_QUERY,',',FIELD_NAME);
			  END IF;
		  END IF;
				
		  IF TRIM(PARAM_IDS)='' THEN
  		  SET PARAM_IDS=CONCAT('''',PARAM_ID,''''); 
		  ELSE
  		  SET PARAM_IDS=CONCAT(PARAM_IDS,',',CONCAT('''',PARAM_ID,'''')); 
		  END IF;
		
  		SET OLD_COLUMN_ID=COLUMN_ID;
		
      FETCH C1 INTO COLUMN_ID,COLUMN_NAME,PARAM_ID,PARAM_TYPE,
			              CP_STRING_BEFORE,CP_STRING_AFTER,CP_USE_STRING_BEFORE,CP_USE_STRING_AFTER,
			              PUBLISHING_ID,VIEW_ID,TYPE_ID,OPERATION_ID,CONDITIONS,SORTING,PRESENTATION_TYPE,PARAM_COUNT;
    END WHILE;
    CLOSE C1;		 

	  SET @QUERY=CONCAT(@QUERY,' FROM /*PREFIX*/OBJECT_PARAMS OP ');
	  SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=OP.OBJECT_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=O.ACCOUNT_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/PUBLISHING_OBJECTS PO ON PO.OBJECT_ID=OP.OBJECT_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/PUBLISHING P ON P.PUBLISHING_ID=PO.PUBLISHING_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=O.VIEW_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=O.TYPE_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/OPERATIONS OT ON OT.OPERATION_ID=O.OPERATION_ID ');
		
	  IF TRIM(PARAM_IDS)<>'' THEN
  	  SET @QUERY=CONCAT(@QUERY,'WHERE OP.PARAM_ID IN (',PARAM_IDS,') ');
		  SET @QUERY=CONCAT(@QUERY,'AND OP.DATE_CREATE=(SELECT MAX(DATE_CREATE) FROM /*PREFIX*/OBJECT_PARAMS WHERE PARAM_ID=OP.PARAM_ID AND OBJECT_ID=O.OBJECT_ID) ');
			IF PUBLISHING_ID IS NOT NULL THEN
  	    SET @QUERY=CONCAT(@QUERY,'AND PO.PUBLISHING_ID=''',PUBLISHING_ID,''' ');
			END IF;
			IF VIEW_ID IS NOT NULL THEN
    	  SET @QUERY=CONCAT(@QUERY,'AND O.VIEW_ID=''',VIEW_ID,''' ');
			END IF;
			IF TYPE_ID IS NOT NULL THEN
    	  SET @QUERY=CONCAT(@QUERY,'AND O.TYPE_ID=''',TYPE_ID,''' ');
			END IF;
			IF OPERATION_ID IS NOT NULL THEN
     	  SET @QUERY=CONCAT(@QUERY,'AND O.OPERATION_ID=''',OPERATION_ID,''' ');
			END IF;
  	  SET @QUERY=CONCAT(@QUERY,'AND PO.DATE_BEGIN>=DATE_ADD(CURRENT_TIMESTAMP,INTERVAL -1 MONTH) ');
  	  SET @QUERY=CONCAT(@QUERY,'AND (PO.DATE_END IS NULL OR PO.DATE_END>=CURRENT_TIMESTAMP) ');
  	  SET @QUERY=CONCAT(@QUERY,'AND O.STATUS IN (0,1) ');
		  SET @QUERY=CONCAT(@QUERY,'GROUP BY OP.OBJECT_ID, PO.PUBLISHING_ID ');
      SET @QUERY=CONCAT(@QUERY,'ORDER BY PO.DATE_BEGIN DESC) T ');
			IF (TRIM(CONVERT(CONDITIONS USING cp1251))<>'') THEN
    	  SET @QUERY=CONCAT(@QUERY,'WHERE ',CONVERT(CONDITIONS USING cp1251),' ');
			END IF;
			IF TRIM(SORTING)<>'' THEN 
        SET @QUERY=CONCAT(@QUERY,'ORDER BY ',SORTING);
			END IF;

			
  	  PREPARE STMT FROM @QUERY;
      EXECUTE STMT;
      DEALLOCATE PREPARE STMT; 

      SET @QUERY=CONCAT('ALTER TABLE /*PREFIX*/',ATABLE,' ADD PRIMARY KEY (OBJECT_ID,PUBLISHING_ID)');
  		PREPARE STMT FROM @QUERY;
      EXECUTE STMT;
      DEALLOCATE PREPARE STMT; 

      SET @QUERY=CONCAT('ALTER TABLE /*PREFIX*/',ATABLE,' ENGINE = MEMORY');
  		PREPARE STMT FROM @QUERY;
      EXECUTE STMT;
      DEALLOCATE PREPARE STMT;       
		
	  END IF;	
  END IF;		
END;

--

/* �������� ������� ���������� ������� */

CREATE TABLE /*PREFIX*/LOCALITIES
(
  LOCALITY_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  PREFIX VARCHAR(10),
  PRIMARY KEY (LOCALITY_ID)
)

--

/* �������� ��������� ���������� ������� */

CREATE VIEW /*PREFIX*/S_LOCALITIES
AS
SELECT * FROM /*PREFIX*/LOCALITIES

--

/* �������� ��������� ���������� ����������� ������ */

CREATE PROCEDURE /*PREFIX*/I_LOCALITY
(
  IN LOCALITY_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN PREFIX VARCHAR(10)
)
BEGIN
  INSERT INTO /*PREFIX*/LOCALITIES (LOCALITY_ID,NAME,PREFIX)
       VALUES (LOCALITY_ID,NAME,PREFIX);
END;

--

/* �������� ��������� ��������� ����������� ������ */

CREATE PROCEDURE /*PREFIX*/U_LOCALITY
(
  IN LOCALITY_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN PREFIX VARCHAR(10),
  IN OLD_LOCALITY_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/LOCALITIES L
     SET L.LOCALITY_ID=LOCALITY_ID,
         L.NAME=NAME,
         L.PREFIX=PREFIX
   WHERE L.LOCALITY_ID=OLD_LOCALITY_ID;
END;

--

/* �������� ��������� �������� ����������� ������ */

CREATE PROCEDURE /*PREFIX*/D_LOCALITY
(
  IN OLD_LOCALITY_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/LOCALITIES 
        WHERE LOCALITY_ID=OLD_LOCALITY_ID;
END;

--

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

ALTER TABLE /*PREFIX*/FIRMS
ADD  INDEX_LEGAL VARCHAR(10)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD STREET_LEGAL_ID VARCHAR(32)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD HOUSE_LEGAL VARCHAR(10)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD FLAT_LEGAL VARCHAR(10)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD INDEX_POST VARCHAR(10)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD STREET_POST_ID VARCHAR(32)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD HOUSE_POST VARCHAR(10)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD FLAT_POST VARCHAR(10)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD FOREIGN KEY (STREET_LEGAL_ID) REFERENCES /*PREFIX*/STREETS (STREET_ID)

--

ALTER TABLE /*PREFIX*/FIRMS
ADD FOREIGN KEY (STREET_POST_ID) REFERENCES /*PREFIX*/STREETS (STREET_ID)

--

/* �������� ��������� ������� ����������� */

DROP VIEW /*PREFIX*/S_FIRMS

--

/* �������� ��������� ������� ����������� */

CREATE VIEW /*PREFIX*/S_FIRMS
AS
  SELECT F.*,
         FT.NAME AS FIRM_TYPE_NAME,
         F1.SMALL_NAME AS PARENT_SMALL_NAME,
         S1.NAME AS STREET_LEGAL_NAME,
         S1.PREFIX AS STREET_LEGAL_PREFIX,
         L1.LOCALITY_ID AS LOCALITY_LEGAL_ID,
         L1.NAME AS LOCALITY_LEGAL_NAME,
         L1.PREFIX AS LOCALITY_LEGAL_PREFIX,
         S2.NAME AS STREET_POST_NAME,
         S2.PREFIX AS STREET_POST_PREFIX,
         L2.LOCALITY_ID AS LOCALITY_POST_ID,
         L2.NAME AS LOCALITY_POST_NAME,
         L2.PREFIX AS LOCALITY_POST_PREFIX
    FROM /*PREFIX*/FIRMS F
    JOIN /*PREFIX*/FIRM_TYPES FT ON FT.FIRM_TYPE_ID=F.FIRM_TYPE_ID
    LEFT JOIN /*PREFIX*/STREETS S1 ON S1.STREET_ID=F.STREET_LEGAL_ID
    LEFT JOIN /*PREFIX*/LOCALITIES L1 ON L1.LOCALITY_ID=S1.LOCALITY_ID
    LEFT JOIN /*PREFIX*/STREETS S2 ON S2.STREET_ID=F.STREET_POST_ID
    LEFT JOIN /*PREFIX*/LOCALITIES L2 ON L2.LOCALITY_ID=S2.LOCALITY_ID
    LEFT JOIN /*PREFIX*/FIRMS F1 ON F1.FIRM_ID=F.PARENT_ID

--

/* �������� ��������� ���������� ����������� */

DROP PROCEDURE /*PREFIX*/I_FIRM

--

/* �������� ��������� ���������� ����������� */

CREATE PROCEDURE /*PREFIX*/I_FIRM
(
  IN FIRM_ID VARCHAR(32),
  IN FIRM_TYPE_ID VARCHAR(32),
  IN PARENT_ID VARCHAR(32),
  IN SMALL_NAME VARCHAR(250),
  IN FULL_NAME VARCHAR(250),
  IN INN VARCHAR(12),
  IN PAYMENT_ACCOUNT VARCHAR(20),
  IN BANK VARCHAR(250),
  IN BIK VARCHAR(20),
  IN CORR_ACCOUNT VARCHAR(20),
  IN PHONE VARCHAR(250),
  IN FAX VARCHAR(250),
  IN EMAIL VARCHAR(100),
  IN SITE VARCHAR(100),
  IN OKONH VARCHAR(20),
  IN OKPO VARCHAR(20),
  IN KPP VARCHAR(20),
  IN DIRECTOR VARCHAR(250),
  IN ACCOUNTANT VARCHAR(250),
  IN CONTACT_FACE VARCHAR(250),
  IN INDEX_LEGAL VARCHAR(10),
  IN STREET_LEGAL_ID VARCHAR(32),
  IN HOUSE_LEGAL VARCHAR(10),
  IN FLAT_LEGAL VARCHAR(10),
  IN INDEX_POST VARCHAR(10),
  IN STREET_POST_ID VARCHAR(32),
  IN HOUSE_POST VARCHAR(10),
  IN FLAT_POST VARCHAR(10)
)
BEGIN
  INSERT INTO /*PREFIX*/FIRMS (FIRM_ID,FIRM_TYPE_ID,PARENT_ID,SMALL_NAME,FULL_NAME,INN,PAYMENT_ACCOUNT,
                               BANK,BIK,CORR_ACCOUNT,PHONE,FAX,EMAIL,SITE,OKONH,OKPO,KPP,DIRECTOR,ACCOUNTANT,
                               CONTACT_FACE,INDEX_LEGAL,STREET_LEGAL_ID,HOUSE_LEGAL,FLAT_LEGAL,
                               INDEX_POST,STREET_POST_ID,HOUSE_POST,FLAT_POST)
       VALUES (FIRM_ID,FIRM_TYPE_ID,PARENT_ID,SMALL_NAME,FULL_NAME,INN,PAYMENT_ACCOUNT,
               BANK,BIK,CORR_ACCOUNT,PHONE,FAX,EMAIL,SITE,OKONH,OKPO,KPP,DIRECTOR,ACCOUNTANT,
               CONTACT_FACE,INDEX_LEGAL,STREET_LEGAL_ID,HOUSE_LEGAL,FLAT_LEGAL,
               INDEX_POST,STREET_POST_ID,HOUSE_POST,FLAT_POST);
END;

--

/* �������� ��������� ��������� ����������� */

DROP PROCEDURE /*PREFIX*/U_FIRM

--

/* �������� ��������� ��������� ����������� */

CREATE PROCEDURE /*PREFIX*/U_FIRM
(
  IN FIRM_ID VARCHAR(32),
  IN FIRM_TYPE_ID VARCHAR(32),
  IN PARENT_ID VARCHAR(32),
  IN SMALL_NAME VARCHAR(250),
  IN FULL_NAME VARCHAR(250),
  IN INN VARCHAR(12),
  IN PAYMENT_ACCOUNT VARCHAR(20),
  IN BANK VARCHAR(250),
  IN BIK VARCHAR(20),
  IN CORR_ACCOUNT VARCHAR(20),
  IN PHONE VARCHAR(250),
  IN FAX VARCHAR(250),
  IN EMAIL VARCHAR(100),
  IN SITE VARCHAR(100),
  IN OKONH VARCHAR(20),
  IN OKPO VARCHAR(20),
  IN KPP VARCHAR(20),
  IN DIRECTOR VARCHAR(250),
  IN ACCOUNTANT VARCHAR(250),
  IN CONTACT_FACE VARCHAR(250),
  IN INDEX_LEGAL VARCHAR(10),
  IN STREET_LEGAL_ID VARCHAR(32),
  IN HOUSE_LEGAL VARCHAR(10),
  IN FLAT_LEGAL VARCHAR(10),
  IN INDEX_POST VARCHAR(10),
  IN STREET_POST_ID VARCHAR(32),
  IN HOUSE_POST VARCHAR(10),
  IN FLAT_POST VARCHAR(10),
  IN OLD_FIRM_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/FIRMS F
     SET F.FIRM_ID=FIRM_ID,
         F.FIRM_TYPE_ID=FIRM_TYPE_ID,
         F.PARENT_ID=PARENT_ID,
         F.SMALL_NAME=SMALL_NAME,
         F.FULL_NAME=FULL_NAME,
         F.INN=INN,
         F.PAYMENT_ACCOUNT=PAYMENT_ACCOUNT,
         F.BANK=BANK,
         F.BIK=BIK,
         F.CORR_ACCOUNT=CORR_ACCOUNT,
         F.PHONE=PHONE,
         F.FAX=FAX,
         F.EMAIL=EMAIL,
         F.SITE=SITE,
         F.OKONH=OKONH,
         F.OKPO=OKPO,
         F.KPP=KPP,
         F.DIRECTOR=DIRECTOR,
         F.ACCOUNTANT=ACCOUNTANT,
         F.CONTACT_FACE=CONTACT_FACE,
         F.INDEX_LEGAL=INDEX_LEGAL,
         F.STREET_LEGAL_ID=STREET_LEGAL_ID,
         F.HOUSE_LEGAL=HOUSE_LEGAL,
         F.FLAT_LEGAL=FLAT_LEGAL,
         F.INDEX_POST=INDEX_POST,
         F.STREET_POST_ID=STREET_POST_ID,
         F.HOUSE_POST=HOUSE_POST,
         F.FLAT_POST=FLAT_POST
   WHERE F.FIRM_ID=OLD_FIRM_ID;
END;

--

/* �������� ��������� �������� ����������� */

DROP PROCEDURE /*PREFIX*/D_FIRM

--

/* �������� ��������� �������� ����������� */

CREATE PROCEDURE /*PREFIX*/D_FIRM
(
  IN OLD_FIRM_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/FIRMS
        WHERE FIRM_ID=OLD_FIRM_ID;
END;

--