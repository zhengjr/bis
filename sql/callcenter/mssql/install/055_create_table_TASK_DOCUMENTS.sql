/* �������� ������� ���������� */

CREATE TABLE /*PREFIX*/TASK_DOCUMENTS
(
  TASK_DOCUMENT_ID VARCHAR(32) NOT NULL,
  TASK_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),  
  DOCUMENT_TYPE INTEGER NOT NULL,
  DATE_DOCUMENT DATETIME NOT NULL,
  DOCUMENT IMAGE NOT NULL,
  EXTENSION VARCHAR(100) NOT NULL,
  PRIMARY KEY (TASK_DOCUMENT_ID),
  FOREIGN KEY (TASK_ID) REFERENCES /*PREFIX*/TASKS (TASK_ID)
)

--

/* �������� ��������� ������� ���������� */

CREATE VIEW /*PREFIX*/S_TASK_DOCUMENTS
AS
   SELECT D.*, 
          DL.DEAL_NUM+' '+A.NAME+' '+CONVERT(VARCHAR(10),T.DATE_CREATE,104)+' '+
          CONVERT(VARCHAR(10),T.DATE_CREATE,108) AS TASK_NAME
     FROM /*PREFIX*/TASK_DOCUMENTS D
     JOIN /*PREFIX*/TASKS T ON T.TASK_ID=D.TASK_ID
     JOIN /*PREFIX*/DEALS DL ON DL.DEAL_ID=T.DEAL_ID
     JOIN /*PREFIX*/ACTIONS A ON A.ACTION_ID=T.ACTION_ID

--

/* �������� ��������� ���������� ��������� */

CREATE PROCEDURE /*PREFIX*/I_TASK_DOCUMENT
  @TASK_DOCUMENT_ID VARCHAR(32),
  @TASK_ID VARCHAR(32),
  @NAME VARCHAR(100),
  @DESCRIPTION VARCHAR(250),  
  @DOCUMENT_TYPE INTEGER,
  @DATE_DOCUMENT DATETIME,
  @DOCUMENT IMAGE,
  @EXTENSION VARCHAR(100)
AS
BEGIN
  INSERT INTO /*PREFIX*/TASK_DOCUMENTS (TASK_DOCUMENT_ID,TASK_ID,NAME,DESCRIPTION,
                                        DOCUMENT_TYPE,DATE_DOCUMENT,DOCUMENT,EXTENSION)
       VALUES (@TASK_DOCUMENT_ID,@TASK_ID,@NAME,@DESCRIPTION,
               @DOCUMENT_TYPE,@DATE_DOCUMENT,@DOCUMENT,@EXTENSION);
END;

--

/* �������� ��������� ��������� ��������� */

CREATE PROCEDURE /*PREFIX*/U_TASK_DOCUMENT
  @TASK_DOCUMENT_ID VARCHAR(32),
  @TASK_ID VARCHAR(32),
  @NAME VARCHAR(100),
  @DESCRIPTION VARCHAR(250),  
  @DOCUMENT_TYPE INTEGER,
  @DATE_DOCUMENT DATETIME,
  @DOCUMENT IMAGE,
  @EXTENSION VARCHAR(100),
  @OLD_TASK_DOCUMENT_ID VARCHAR(32)
AS
BEGIN
  UPDATE /*PREFIX*/TASK_DOCUMENTS
     SET TASK_DOCUMENT_ID=@TASK_DOCUMENT_ID,
         TASK_ID=@TASK_ID,
         NAME=@NAME,
         DESCRIPTION=@DESCRIPTION,
         DOCUMENT_TYPE=@DOCUMENT_TYPE,
         DATE_DOCUMENT=@DATE_DOCUMENT,
         DOCUMENT=@DOCUMENT,
         EXTENSION=@EXTENSION
   WHERE TASK_DOCUMENT_ID=@OLD_TASK_DOCUMENT_ID;
END;

--

/* �������� ��������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/D_TASK_DOCUMENT
  @OLD_TASK_DOCUMENT_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/TASK_DOCUMENTS
        WHERE TASK_DOCUMENT_ID=@OLD_TASK_DOCUMENT_ID;
END;

--