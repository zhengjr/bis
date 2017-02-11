/* �������� ������� ������� */

CREATE TABLE /*PREFIX*/REPORTS
(
  REPORT_ID VARCHAR(32) NOT NULL,
  REPORT_TYPE INTEGER NOT NULL,
  REPORT BLOB NOT NULL,
  PLACE INTEGER NOT NULL,
  PRIMARY KEY (REPORT_ID),
  FOREIGN KEY (REPORT_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ������� */

CREATE VIEW /*PREFIX*/S_REPORTS
AS
  SELECT R.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/REPORTS R
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=R.REPORT_ID

--

/* �������� ��������� ���������� ������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/I_REPORT
(
  REPORT_ID IN VARCHAR2,
  REPORT_TYPE IN INTEGER,
  REPORT IN BLOB,
  PLACE IN INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/REPORTS (REPORT_ID,REPORT_TYPE,REPORT,PLACE)
       VALUES (REPORT_ID,REPORT_TYPE,REPORT,PLACE);
END;

--

/* �������� ��������� ��������� ������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/U_REPORT
(
  REPORT_ID IN VARCHAR2,
  REPORT_TYPE IN INTEGER,
  REPORT IN BLOB,
  PLACE IN INTEGER,
  OLD_REPORT_ID IN VARCHAR2
)
AS
BEGIN
  UPDATE /*PREFIX*/REPORTS
     SET REPORT_ID=U_REPORT.REPORT_ID,
         REPORT_TYPE=U_REPORT.REPORT_TYPE,
         REPORT=U_REPORT.REPORT,
         PLACE=U_REPORT.PLACE
   WHERE REPORT_ID=OLD_REPORT_ID;
END;

--

/* �������� ��������� �������� ������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/D_REPORT
(
  OLD_REPORT_ID IN VARCHAR2
)
AS
BEGIN
  DELETE FROM /*PREFIX*/REPORTS
        WHERE REPORT_ID=OLD_REPORT_ID;
END;

--

/* �������� ��������� */

COMMIT