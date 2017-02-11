/* �������� ������� ��������� �������� */

CREATE TABLE /*PREFIX*/VARIANTS
(
  VARIANT_ID VARCHAR(32) NOT NULL,
  CURRENCY_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  PROC_NAME VARCHAR(30),
  PRIMARY KEY (VARIANT_ID),
  FOREIGN KEY (CURRENCY_ID) REFERENCES /*PREFIX*/CURRENCY (CURRENCY_ID)
)

--

/* �������� ��������� ������� ��������� �������� */

CREATE VIEW /*PREFIX*/S_VARIANTS
AS
   SELECT V.*, 
          C.NAME AS CURRENCY_NAME
     FROM /*PREFIX*/VARIANTS V
     JOIN /*PREFIX*/CURRENCY C ON V.CURRENCY_ID=C.CURRENCY_ID

--

/* �������� ��������� ���������� �������� ������� */

CREATE PROCEDURE /*PREFIX*/I_VARIANT
  @VARIANT_ID VARCHAR(32),
  @CURRENCY_ID VARCHAR(32),
  @NAME VARCHAR(100),
  @DESCRIPTION VARCHAR(250),
  @PROC_NAME VARCHAR(30)
AS
BEGIN
  INSERT INTO /*PREFIX*/VARIANTS (VARIANT_ID,CURRENCY_ID,NAME,DESCRIPTION,PROC_NAME)
       VALUES (@VARIANT_ID,@CURRENCY_ID,@NAME,@DESCRIPTION,@PROC_NAME);
END;

--

/* �������� ��������� ��������� �������� ������� */

CREATE PROCEDURE /*PREFIX*/U_VARIANT
  @VARIANT_ID VARCHAR(32),
  @CURRENCY_ID VARCHAR(32),
  @NAME VARCHAR(100),
  @DESCRIPTION VARCHAR(250),
  @PROC_NAME VARCHAR(30),
  @OLD_VARIANT_ID VARCHAR(32)
AS
BEGIN
  UPDATE /*PREFIX*/VARIANTS
     SET VARIANT_ID=@VARIANT_ID,
         CURRENCY_ID=@CURRENCY_ID,
         NAME=@NAME,
         DESCRIPTION=@DESCRIPTION,
	 PROC_NAME=@PROC_NAME
   WHERE VARIANT_ID=@OLD_VARIANT_ID;
END;

--

/* �������� ��������� �������� �������� ������� */

CREATE PROCEDURE /*PREFIX*/D_VARIANT
  @OLD_VARIANT_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/VARIANTS
        WHERE VARIANT_ID=@OLD_VARIANT_ID;
END;

--