/* �������� ������� �������� ��������� */

CREATE TABLE /*PREFIX*/IN_MESSAGES
(
  IN_MESSAGE_ID VARCHAR(32) NOT NULL,
  SENDER_ID VARCHAR(32),
  CODE_MESSAGE_ID VARCHAR(32),
  DATE_SEND TIMESTAMP NOT NULL,
  TEXT_IN VARCHAR(4000),
  DATE_IN TIMESTAMP NOT NULL,
  TYPE_MESSAGE INTEGER NOT NULL,
  CONTACT VARCHAR(100) NOT NULL,
  PRIMARY KEY (IN_MESSAGE_ID),
  FOREIGN KEY (SENDER_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (CODE_MESSAGE_ID) REFERENCES /*PREFIX*/CODE_MESSAGES (CODE_MESSAGE_ID)
)

--

/* �������� ��������� �������� ��������� */

CREATE VIEW /*PREFIX*/S_IN_MESSAGES
(
  IN_MESSAGE_ID,
  SENDER_ID,
  CODE_MESSAGE_ID,
  DATE_SEND,
  TEXT_IN,
  DATE_IN,
  TYPE_MESSAGE,
  CONTACT,
  SENDER_NAME,
  CODE
)
AS
SELECT IM.*,
       A.USER_NAME AS SENDER_NAME,
       CM.CODE
  FROM /*PREFIX*/IN_MESSAGES IM
  LEFT JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=IM.SENDER_ID
  LEFT JOIN /*PREFIX*/CODE_MESSAGES CM ON CM.CODE_MESSAGE_ID=IM.CODE_MESSAGE_ID

--

/* �������� ��������� ���������� ��������� ��������� */

CREATE PROCEDURE /*PREFIX*/I_IN_MESSAGE
(
  IN_MESSAGE_ID VARCHAR(32),
  SENDER_ID VARCHAR(32),
  CODE_MESSAGE_ID VARCHAR(32),
  DATE_SEND TIMESTAMP,
  TEXT_IN VARCHAR(4000),
  DATE_IN TIMESTAMP,
  TYPE_MESSAGE INTEGER,
  CONTACT VARCHAR(100)
)
AS
BEGIN
  IF (DATE_IN IS NULL) THEN BEGIN
    DATE_IN=CURRENT_TIMESTAMP;
  END

  INSERT INTO /*PREFIX*/IN_MESSAGES (IN_MESSAGE_ID,SENDER_ID,CODE_MESSAGE_ID,DATE_SEND,
                                     TEXT_IN,DATE_IN,TYPE_MESSAGE,CONTACT)
       VALUES (:IN_MESSAGE_ID,:SENDER_ID,:CODE_MESSAGE_ID,:DATE_SEND,
               :TEXT_IN,:DATE_IN,:TYPE_MESSAGE,:CONTACT);
END;

--

/* �������� ��������� ��������� ��������� ��������� */

CREATE PROCEDURE /*PREFIX*/U_IN_MESSAGE
(
  IN_MESSAGE_ID VARCHAR(32),
  SENDER_ID VARCHAR(32),
  CODE_MESSAGE_ID VARCHAR(32),
  DATE_SEND TIMESTAMP,
  TEXT_IN VARCHAR(4000),
  DATE_IN TIMESTAMP,
  TYPE_MESSAGE INTEGER,
  CONTACT VARCHAR(100),
  OLD_IN_MESSAGE_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/IN_MESSAGES
     SET IN_MESSAGE_ID=:IN_MESSAGE_ID,
         SENDER_ID=:SENDER_ID,
         CODE_MESSAGE_ID=:CODE_MESSAGE_ID,
         DATE_SEND=:DATE_SEND,
         TEXT_IN=:TEXT_IN,
         DATE_IN=:DATE_IN,
         TYPE_MESSAGE=:TYPE_MESSAGE,
         CONTACT=:CONTACT
   WHERE IN_MESSAGE_ID=:OLD_IN_MESSAGE_ID;
END;

--

/* �������� ��������� �������� ��������� ��������� */

CREATE PROCEDURE /*PREFIX*/D_IN_MESSAGE
(
  OLD_IN_MESSAGE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/IN_MESSAGES 
        WHERE IN_MESSAGE_ID=:OLD_IN_MESSAGE_ID;
END;

--