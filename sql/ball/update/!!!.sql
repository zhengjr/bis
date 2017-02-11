/* ���������� ������� ������� ������� */ 

ALTER TABLE ACCOUNTS
ADD PHONE_INTERNAL VARCHAR(100)

--

/* ���������� ��������� ������� ������� */ 

CREATE OR ALTER VIEW S_ACCOUNTS
AS
SELECT A.*, 
       F.SMALL_NAME AS FIRM_SMALL_NAME
  FROM ACCOUNTS A
  LEFT JOIN FIRMS F ON F.FIRM_ID=A.FIRM_ID

--

/* ��������� ��������� �������� ������� ������ */ 

CREATE OR ALTER PROCEDURE I_ACCOUNT
(
  ACCOUNT_ID VARCHAR(32),
  FIRM_ID VARCHAR(32),
  DATE_CREATE TIMESTAMP,
  USER_NAME VARCHAR(100),
  "PASSWORD" VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  DB_USER_NAME VARCHAR(100),
  DB_PASSWORD VARCHAR(100),
  IS_ROLE INTEGER,
  LOCKED INTEGER,
  AUTO_CREATED INTEGER,
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  PHONE VARCHAR(100),
  EMAIL VARCHAR(100),
  PHOTO BLOB,
  JOB_TITLE VARCHAR(250),
  PHONE_INTERNAL VARCHAR(100)
)
AS
BEGIN
  INSERT INTO ACCOUNTS (ACCOUNT_ID,FIRM_ID,DATE_CREATE,USER_NAME,"PASSWORD",DESCRIPTION,DB_USER_NAME,DB_PASSWORD,
                        IS_ROLE,LOCKED,AUTO_CREATED,SURNAME,NAME,PATRONYMIC,PHONE,EMAIL,PHOTO,JOB_TITLE,PHONE_INTERNAL)
       VALUES (:ACCOUNT_ID,:FIRM_ID,:DATE_CREATE,:USER_NAME,:"PASSWORD",:DESCRIPTION,:DB_USER_NAME,:DB_PASSWORD,
               :IS_ROLE,:LOCKED,:AUTO_CREATED,:SURNAME,:NAME,:PATRONYMIC,:PHONE,:EMAIL,:PHOTO,:JOB_TITLE,:PHONE_INTERNAL);
END

--

/* ��������� ��������� ���������� ������� ������ */ 

CREATE OR ALTER PROCEDURE U_ACCOUNT
(
  ACCOUNT_ID VARCHAR(32),
  FIRM_ID VARCHAR(32),
  DATE_CREATE TIMESTAMP,
  USER_NAME VARCHAR(100),
  "PASSWORD" VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  DB_USER_NAME VARCHAR(100),
  DB_PASSWORD VARCHAR(100),
  IS_ROLE INTEGER,
  LOCKED INTEGER,
  AUTO_CREATED INTEGER,
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  PHONE VARCHAR(100),
  EMAIL VARCHAR(100),
  PHOTO BLOB,
  JOB_TITLE VARCHAR(250),
  PHONE_INTERNAL VARCHAR(100),
  OLD_ACCOUNT_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE ACCOUNTS
     SET ACCOUNT_ID=:ACCOUNT_ID,
         FIRM_ID=:FIRM_ID,
         DATE_CREATE=:DATE_CREATE,
         USER_NAME=:USER_NAME,
         "PASSWORD"=:"PASSWORD",
         DESCRIPTION=:DESCRIPTION,
         DB_USER_NAME=:DB_USER_NAME,
         DB_PASSWORD=:DB_PASSWORD,
         IS_ROLE=:IS_ROLE,
         LOCKED=:LOCKED,
         AUTO_CREATED=:AUTO_CREATED,
         SURNAME=:SURNAME,
         NAME=:NAME,
         PATRONYMIC=:PATRONYMIC,
         PHONE=:PHONE,
         EMAIL=:EMAIL,
         PHOTO=:PHOTO,
         JOB_TITLE=:JOB_TITLE,
         PHONE_INTERNAL=:PHONE_INTERNAL
   WHERE ACCOUNT_ID=:OLD_ACCOUNT_ID;
END

--

/* �������� ��������� ������� */ 

CREATE GLOBAL TEMPORARY TABLE TMP_NUMBERS
(
  BARREL_NUM VARCHAR(2),
  PRIMARY KEY (BARREL_NUM)
)

--

/* ��������� ��������� ��������� ���������� ������� */ 

CREATE OR ALTER PROCEDURE GET_LOTTERY_STATISTICS
(
  TIRAGE_ID VARCHAR(32)
)
RETURNS
(
  TICKET_COST NUMERIC(15,2),
  PRIZE_PERCENT NUMERIC(4,2),
  JACKPOT_PERCENT NUMERIC(4,2),
  FIRST_PERCENT NUMERIC(4,2),
  SECOND_1_ROUND_PERCENT NUMERIC(4,2),
  SECOND_2_ROUND_PERCENT NUMERIC(4,2),
  SECOND_3_ROUND_PERCENT NUMERIC(4,2),
  SECOND_4_ROUND_PERCENT NUMERIC(4,2),
  ALL_COUNT INTEGER,
  USED_COUNT INTEGER,
  NOT_USED_COUNT INTEGER,
  PRIZE_SUM NUMERIC(15,2),
  JACKPOT_SUM NUMERIC(15,2),
  FIRST_SUM NUMERIC(15,2),
  SECOND_1_ROUND_SUM NUMERIC(15,2),
  SECOND_2_ROUND_SUM NUMERIC(15,2),
  SECOND_3_ROUND_SUM NUMERIC(15,2),
  SECOND_4_ROUND_SUM NUMERIC(15,2),
  WINNING_COUNT INTEGER,
  NOT_DROPPED_COUNT INTEGER,
  NOT_DROPPED_NUMBERS VARCHAR(1000)
)
AS
DECLARE TEMP_SUM NUMERIC(15,2);
DECLARE BARREL_NUM VARCHAR(2);
DECLARE NUM INTEGER;
BEGIN

  SELECT TICKET_COST, PRIZE_PERCENT, JACKPOT_PERCENT, FIRST_PERCENT,
         SECOND_1_ROUND_PERCENT, SECOND_2_ROUND_PERCENT,
         SECOND_3_ROUND_PERCENT, SECOND_4_ROUND_PERCENT
    FROM TIRAGES
   WHERE TIRAGE_ID=:TIRAGE_ID
    INTO :TICKET_COST, :PRIZE_PERCENT, :JACKPOT_PERCENT, :FIRST_PERCENT,
         :SECOND_1_ROUND_PERCENT, :SECOND_2_ROUND_PERCENT,
         :SECOND_3_ROUND_PERCENT, :SECOND_4_ROUND_PERCENT;

  EXECUTE PROCEDURE GET_TIRAGE_STATISTICS(TIRAGE_ID,TICKET_COST,PRIZE_PERCENT,JACKPOT_PERCENT,FIRST_PERCENT,
                                          SECOND_1_ROUND_PERCENT,SECOND_2_ROUND_PERCENT,
                                          SECOND_3_ROUND_PERCENT,SECOND_4_ROUND_PERCENT)
   RETURNING_VALUES (ALL_COUNT,USED_COUNT,NOT_USED_COUNT,PRIZE_SUM,JACKPOT_SUM,FIRST_SUM,
                     SECOND_1_ROUND_SUM,SECOND_2_ROUND_SUM,SECOND_3_ROUND_SUM,SECOND_4_ROUND_SUM);

  SELECT COUNT(*)
    FROM WINNINGS W
    JOIN LOTTERY L ON L.LOTTERY_ID=W.LOTTERY_ID
   WHERE L.TIRAGE_ID=:TIRAGE_ID
    INTO :WINNING_COUNT;


  NUM=0;
  DELETE FROM TMP_NUMBERS;

  WHILE (NUM<77) DO BEGIN
    NUM=NUM+1;

    IF (NUM<10) THEN
      BARREL_NUM='0'||CAST(NUM AS VARCHAR(1));
    ELSE
      BARREL_NUM=CAST(NUM AS VARCHAR(2));

    INSERT INTO TMP_NUMBERS (BARREL_NUM)
                     VALUES (:BARREL_NUM);
  END


  NOT_DROPPED_COUNT=0;
  FOR SELECT BARREL_NUM
        FROM TMP_NUMBERS
       WHERE BARREL_NUM NOT IN (SELECT BARREL_NUM
                                  FROM LOTTERY
                                 WHERE TIRAGE_ID=:TIRAGE_ID)
       ORDER BY BARREL_NUM
        INTO :BARREL_NUM DO BEGIN

    IF (NOT_DROPPED_COUNT=0) THEN
      NOT_DROPPED_NUMBERS=BARREL_NUM;
    ELSE
      NOT_DROPPED_NUMBERS=NOT_DROPPED_NUMBERS||','||BARREL_NUM;

    NOT_DROPPED_COUNT=NOT_DROPPED_COUNT+1;

  END

END

--

/* ��������� ��������� ��������� ��������� */ 

CREATE OR ALTER PROCEDURE GET_PROTOCOL
(
  TIRAGE_ID VARCHAR(32)
)
RETURNS
(
  TICKET_ID VARCHAR(32),
  ROUND_NUM INTEGER,
  SUBROUND_NAME VARCHAR(100),
  NUM VARCHAR(8),
  SERIES VARCHAR(5),
  DEALER_ID VARCHAR(32),
  DEALER_SMALL_NAME VARCHAR(250),
  PRIZE_NAME VARCHAR(40),
  PRIZE_COST NUMERIC(15,4),
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  ADDRESS VARCHAR(250),
  PHONE VARCHAR(100)
)
AS
  DECLARE TICKET_COST NUMERIC(15,2);
  DECLARE PRIZE_PERCENT NUMERIC(4,2);
  DECLARE JACKPOT_PERCENT NUMERIC(4,2);
  DECLARE FIRST_PERCENT NUMERIC(4,2);
  DECLARE SECOND_1_ROUND_PERCENT NUMERIC(4,2);
  DECLARE SECOND_2_ROUND_PERCENT NUMERIC(4,2);
  DECLARE SECOND_3_ROUND_PERCENT NUMERIC(4,2);
  DECLARE SECOND_4_ROUND_PERCENT NUMERIC(4,2);
  DECLARE WINNING_COUNT INTEGER;
  DECLARE NOT_DROPPED_COUNT INTEGER;
  DECLARE NOT_DROPPED_NUMBERS VARCHAR(1000);
  DECLARE ALL_COUNT INTEGER;
  DECLARE USED_COUNT INTEGER;
  DECLARE NOT_USED_COUNT INTEGER;
  DECLARE PRIZE_SUM NUMERIC(15,2);
  DECLARE JACKPOT_SUM NUMERIC(15,2);
  DECLARE FIRST_SUM NUMERIC(15,2);
  DECLARE SECOND_1_ROUND_SUM NUMERIC(15,2);
  DECLARE SECOND_2_ROUND_SUM NUMERIC(15,2);
  DECLARE SECOND_3_ROUND_SUM NUMERIC(15,2);
  DECLARE SECOND_4_ROUND_SUM NUMERIC(15,2);
  DECLARE TICKET_COUNT INTEGER;
  DECLARE SUBROUND_ID VARCHAR(32);
  DECLARE SUBROUND_PERCENT NUMERIC(4,2);
BEGIN

  EXECUTE PROCEDURE GET_LOTTERY_STATISTICS(:TIRAGE_ID)
   RETURNING_VALUES :TICKET_COST, PRIZE_PERCENT, JACKPOT_PERCENT, FIRST_PERCENT,
                    :SECOND_1_ROUND_PERCENT, :SECOND_2_ROUND_PERCENT, SECOND_3_ROUND_PERCENT, :SECOND_4_ROUND_PERCENT,
                    :ALL_COUNT, :USED_COUNT, :NOT_USED_COUNT, :PRIZE_SUM, :JACKPOT_SUM, :FIRST_SUM,
                    :SECOND_1_ROUND_SUM, :SECOND_2_ROUND_SUM, :SECOND_3_ROUND_SUM, :SECOND_4_ROUND_SUM,
                    :WINNING_COUNT, :NOT_DROPPED_COUNT, :NOT_DROPPED_NUMBERS;

  SELECT COUNT(*)
    FROM WINNINGS
   WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                          FROM LOTTERY
                         WHERE TIRAGE_ID=:TIRAGE_ID
                           AND ROUND_NUM=1
                           AND SUBROUND_ID IS NULL) 
    INTO :TICKET_COUNT;

  IF (TICKET_COUNT=0) THEN TICKET_COUNT=1;

  PRIZE_NAME='�������� ����';
  PRIZE_COST=SECOND_1_ROUND_SUM/TICKET_COUNT;

  FOR SELECT W.TICKET_ID,1,NULL,T.NUM,T.SERIES,
             T.DEALER_ID,F.SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
             T.SURNAME,T.NAME,T.PATRONYMIC,T.ADDRESS,T.PHONE
        FROM WINNINGS W
        JOIN LOTTERY L ON L.LOTTERY_ID=W.LOTTERY_ID
        JOIN TICKETS T ON T.TICKET_ID=W.TICKET_ID
        LEFT JOIN DEALERS D ON D.DEALER_ID=T.DEALER_ID
        LEFT JOIN FIRMS F ON F.FIRM_ID=D.DEALER_ID
       WHERE W.LOTTERY_ID IN (SELECT LOTTERY_ID
                                FROM LOTTERY
                               WHERE TIRAGE_ID=:TIRAGE_ID
                                 AND ROUND_NUM=1
                                 AND SUBROUND_ID IS NULL)
         AND L.TIRAGE_ID=:TIRAGE_ID
       ORDER BY L.PRIORITY
        INTO :TICKET_ID,:ROUND_NUM,:SUBROUND_NAME,:NUM,:SERIES,
             :DEALER_ID,:DEALER_SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
             :SURNAME,:NAME,:PATRONYMIC,:ADDRESS,:PHONE DO BEGIN
    SUSPEND;
  END

  SELECT COUNT(*)
    FROM WINNINGS
   WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                          FROM LOTTERY
                         WHERE TIRAGE_ID=:TIRAGE_ID
                           AND ROUND_NUM=2
                           AND SUBROUND_ID IS NULL)
    INTO :TICKET_COUNT;

  IF (TICKET_COUNT=0) THEN TICKET_COUNT=1;

  PRIZE_NAME='�������� ����';
  PRIZE_COST=SECOND_2_ROUND_SUM/TICKET_COUNT;

  FOR SELECT W.TICKET_ID,2,NULL,T.NUM,T.SERIES,
             T.DEALER_ID,F.SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
             T.SURNAME,T.NAME,T.PATRONYMIC,T.ADDRESS,T.PHONE
        FROM WINNINGS W
        JOIN LOTTERY L ON L.LOTTERY_ID=W.LOTTERY_ID
        JOIN TICKETS T ON T.TICKET_ID=W.TICKET_ID
        LEFT JOIN DEALERS D ON D.DEALER_ID=T.DEALER_ID
        LEFT JOIN FIRMS F ON F.FIRM_ID=D.DEALER_ID
       WHERE W.LOTTERY_ID IN (SELECT LOTTERY_ID
                                FROM LOTTERY
                               WHERE TIRAGE_ID=:TIRAGE_ID
                                 AND ROUND_NUM=2
                                 AND SUBROUND_ID IS NULL)
         AND L.TIRAGE_ID=:TIRAGE_ID
       ORDER BY L.PRIORITY
        INTO :TICKET_ID,:ROUND_NUM,:SUBROUND_NAME,:NUM,:SERIES,
             :DEALER_ID,:DEALER_SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
             :SURNAME,:NAME,:PATRONYMIC,:ADDRESS,:PHONE DO BEGIN
    SUSPEND;
  END

  SELECT COUNT(*)
    FROM WINNINGS
   WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                          FROM LOTTERY
                         WHERE TIRAGE_ID=:TIRAGE_ID
                           AND ROUND_NUM=3
                           AND SUBROUND_ID IS NULL)
    INTO :TICKET_COUNT;
    
  IF (TICKET_COUNT=0) THEN TICKET_COUNT=1;

  PRIZE_NAME='�������� ����';
  PRIZE_COST=SECOND_3_ROUND_SUM/TICKET_COUNT;

  FOR SELECT W.TICKET_ID,3,NULL,T.NUM,T.SERIES,
             T.DEALER_ID,F.SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
             T.SURNAME,T.NAME,T.PATRONYMIC,T.ADDRESS,T.PHONE
        FROM WINNINGS W
        JOIN LOTTERY L ON L.LOTTERY_ID=W.LOTTERY_ID
        JOIN TICKETS T ON T.TICKET_ID=W.TICKET_ID
        LEFT JOIN DEALERS D ON D.DEALER_ID=T.DEALER_ID
        LEFT JOIN FIRMS F ON F.FIRM_ID=D.DEALER_ID
       WHERE W.LOTTERY_ID IN (SELECT LOTTERY_ID
                                FROM LOTTERY
                               WHERE TIRAGE_ID=:TIRAGE_ID
                                 AND ROUND_NUM=3
                                 AND SUBROUND_ID IS NULL)
         AND L.TIRAGE_ID=:TIRAGE_ID
       ORDER BY L.PRIORITY
        INTO :TICKET_ID,:ROUND_NUM,:SUBROUND_NAME,:NUM,:SERIES,
             :DEALER_ID,:DEALER_SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
             :SURNAME,:NAME,:PATRONYMIC,:ADDRESS,:PHONE DO BEGIN
    SUSPEND;
  END

  FOR SELECT SUBROUND_ID, NAME, PERCENT
        FROM SUBROUNDS
       WHERE TIRAGE_ID=:TIRAGE_ID
       ORDER BY PRIORITY
        INTO :SUBROUND_ID, :SUBROUND_NAME, :SUBROUND_PERCENT DO BEGIN

    SELECT COUNT(*)
      FROM WINNINGS
      WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                             FROM LOTTERY
                            WHERE TIRAGE_ID=:TIRAGE_ID
                              AND ROUND_NUM=4
                              AND SUBROUND_ID=:SUBROUND_ID)
       INTO :TICKET_COUNT;

    IF (TICKET_COUNT=0) THEN TICKET_COUNT=1;

    PRIZE_NAME='�������� ����';
    PRIZE_COST=SECOND_4_ROUND_SUM*(SUBROUND_PERCENT/100)/TICKET_COUNT;

    FOR SELECT W.TICKET_ID,4,:SUBROUND_NAME,T.NUM,T.SERIES,
               T.DEALER_ID,F.SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
               T.SURNAME,T.NAME,T.PATRONYMIC,T.ADDRESS,T.PHONE
          FROM WINNINGS W
          JOIN LOTTERY L ON L.LOTTERY_ID=W.LOTTERY_ID
          JOIN TICKETS T ON T.TICKET_ID=W.TICKET_ID
          LEFT JOIN DEALERS D ON D.DEALER_ID=T.DEALER_ID
          LEFT JOIN FIRMS F ON F.FIRM_ID=D.DEALER_ID
         WHERE W.LOTTERY_ID IN (SELECT LOTTERY_ID
                                  FROM LOTTERY
                                 WHERE TIRAGE_ID=:TIRAGE_ID
                                   AND ROUND_NUM=4
                                   AND SUBROUND_ID=:SUBROUND_ID)
           AND L.TIRAGE_ID=:TIRAGE_ID
         ORDER BY L.PRIORITY
          INTO :TICKET_ID,:ROUND_NUM,:SUBROUND_NAME,:NUM,:SERIES,
               :DEALER_ID,:DEALER_SMALL_NAME,:PRIZE_NAME,:PRIZE_COST,
               :SURNAME,:NAME,:PATRONYMIC,:ADDRESS,:PHONE DO BEGIN
      SUSPEND;
    END
  END

END

--

/* �������� ��������� ��������� ���� ��������� */ 

CREATE OR ALTER PROCEDURE GET_STATEMENT
(
  TIRAGE_ID VARCHAR(32)
)
RETURNS
(
  ROUND_NUM INTEGER,
  SUBROUND_NAME VARCHAR(100),
  NUMBERS VARCHAR(1000),
  WINNING_COUNT INTEGER,
  PRIZE_COST NUMERIC(15,4)
)
AS
  DECLARE TICKET_COST NUMERIC(15,2);
  DECLARE PRIZE_PERCENT NUMERIC(4,2);
  DECLARE JACKPOT_PERCENT NUMERIC(4,2);
  DECLARE FIRST_PERCENT NUMERIC(4,2);
  DECLARE SECOND_1_ROUND_PERCENT NUMERIC(4,2);
  DECLARE SECOND_2_ROUND_PERCENT NUMERIC(4,2);
  DECLARE SECOND_3_ROUND_PERCENT NUMERIC(4,2);
  DECLARE SECOND_4_ROUND_PERCENT NUMERIC(4,2);
  DECLARE ALL_WINNING_COUNT INTEGER;
  DECLARE NOT_DROPPED_COUNT INTEGER;
  DECLARE NOT_DROPPED_NUMBERS VARCHAR(1000);
  DECLARE ALL_COUNT INTEGER;
  DECLARE USED_COUNT INTEGER;
  DECLARE NOT_USED_COUNT INTEGER;
  DECLARE PRIZE_SUM NUMERIC(15,2);
  DECLARE JACKPOT_SUM NUMERIC(15,2);
  DECLARE FIRST_SUM NUMERIC(15,2);
  DECLARE SECOND_1_ROUND_SUM NUMERIC(15,2);
  DECLARE SECOND_2_ROUND_SUM NUMERIC(15,2);
  DECLARE SECOND_3_ROUND_SUM NUMERIC(15,2);
  DECLARE SECOND_4_ROUND_SUM NUMERIC(15,2);
  DECLARE TICKET_COUNT INTEGER;
  DECLARE SUBROUND_ID VARCHAR(32);
  DECLARE SUBROUND_PERCENT NUMERIC(4,2);
  DECLARE BARREL_NUM VARCHAR(2);
  DECLARE COUNTER INTEGER;
BEGIN

  EXECUTE PROCEDURE GET_LOTTERY_STATISTICS(:TIRAGE_ID)
   RETURNING_VALUES :TICKET_COST, PRIZE_PERCENT, JACKPOT_PERCENT, FIRST_PERCENT,
                    :SECOND_1_ROUND_PERCENT, :SECOND_2_ROUND_PERCENT, SECOND_3_ROUND_PERCENT, :SECOND_4_ROUND_PERCENT,
                    :ALL_COUNT, :USED_COUNT, :NOT_USED_COUNT, :PRIZE_SUM, :JACKPOT_SUM, :FIRST_SUM,
                    :SECOND_1_ROUND_SUM, :SECOND_2_ROUND_SUM, :SECOND_3_ROUND_SUM, :SECOND_4_ROUND_SUM,
                    :ALL_WINNING_COUNT, :NOT_DROPPED_COUNT, :NOT_DROPPED_NUMBERS;

  ROUND_NUM=1;

  SELECT COUNT(*)
    FROM WINNINGS
   WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                          FROM LOTTERY
                         WHERE TIRAGE_ID=:TIRAGE_ID
                           AND ROUND_NUM=:ROUND_NUM
                           AND SUBROUND_ID IS NULL) 
    INTO :TICKET_COUNT;

  IF (TICKET_COUNT>=0) THEN BEGIN

    SUBROUND_NAME=NULL;
    NUMBERS=NULL;
    WINNING_COUNT=TICKET_COUNT;
    IF (TICKET_COUNT>0) THEN
      PRIZE_COST=SECOND_1_ROUND_SUM/TICKET_COUNT;
    ELSE
      PRIZE_COST=NULL;
    COUNTER=0;

    FOR SELECT BARREL_NUM
          FROM LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND ROUND_NUM=:ROUND_NUM
           AND SUBROUND_ID IS NULL
         ORDER BY PRIORITY
          INTO :BARREL_NUM DO BEGIN

      IF (COUNTER=0) THEN
        NUMBERS=BARREL_NUM;
      ELSE
        NUMBERS=NUMBERS||','||BARREL_NUM;

      COUNTER=COUNTER+1;

    END

    SUSPEND;

  END

  ROUND_NUM=2;

  SELECT COUNT(*)
    FROM WINNINGS
   WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                          FROM LOTTERY
                         WHERE TIRAGE_ID=:TIRAGE_ID
                           AND ROUND_NUM=:ROUND_NUM
                           AND SUBROUND_ID IS NULL) 
    INTO :TICKET_COUNT;

  IF (TICKET_COUNT>=0) THEN BEGIN

    SUBROUND_NAME=NULL;
    NUMBERS=NULL;
    WINNING_COUNT=TICKET_COUNT;
    IF (TICKET_COUNT>0) THEN
      PRIZE_COST=SECOND_2_ROUND_SUM/TICKET_COUNT;
    ELSE
      PRIZE_COST=NULL;
    COUNTER=0;

    FOR SELECT BARREL_NUM
          FROM LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND ROUND_NUM=:ROUND_NUM
           AND SUBROUND_ID IS NULL
         ORDER BY PRIORITY
          INTO :BARREL_NUM DO BEGIN

      IF (COUNTER=0) THEN
        NUMBERS=BARREL_NUM;
      ELSE
        NUMBERS=NUMBERS||','||BARREL_NUM;

      COUNTER=COUNTER+1;

    END

    SUSPEND;

  END

  ROUND_NUM=3;

  SELECT COUNT(*)
    FROM WINNINGS
   WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                          FROM LOTTERY
                         WHERE TIRAGE_ID=:TIRAGE_ID
                           AND ROUND_NUM=:ROUND_NUM
                           AND SUBROUND_ID IS NULL) 
    INTO :TICKET_COUNT;

  IF (TICKET_COUNT>=0) THEN BEGIN

    SUBROUND_NAME=NULL;
    NUMBERS=NULL;
    WINNING_COUNT=TICKET_COUNT;
    IF (TICKET_COUNT>0) THEN
      PRIZE_COST=SECOND_3_ROUND_SUM/TICKET_COUNT;
    ELSE
      PRIZE_COST=NULL;
    COUNTER=0;

    FOR SELECT BARREL_NUM
          FROM LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND ROUND_NUM=:ROUND_NUM
           AND SUBROUND_ID IS NULL
         ORDER BY PRIORITY
          INTO :BARREL_NUM DO BEGIN

      IF (COUNTER=0) THEN
        NUMBERS=BARREL_NUM;
      ELSE
        NUMBERS=NUMBERS||','||BARREL_NUM;

      COUNTER=COUNTER+1;

    END

    SUSPEND;

  END

  ROUND_NUM=4;

  FOR SELECT SUBROUND_ID, NAME, PERCENT
        FROM SUBROUNDS
       WHERE TIRAGE_ID=:TIRAGE_ID
       ORDER BY PRIORITY
        INTO :SUBROUND_ID, :SUBROUND_NAME, :SUBROUND_PERCENT DO BEGIN

    SELECT COUNT(*)
      FROM WINNINGS
      WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                             FROM LOTTERY
                            WHERE TIRAGE_ID=:TIRAGE_ID
                              AND ROUND_NUM=:ROUND_NUM
                              AND SUBROUND_ID=:SUBROUND_ID)
       INTO :TICKET_COUNT;

    IF (TICKET_COUNT>=0) THEN BEGIN

      NUMBERS=NULL;
      WINNING_COUNT=TICKET_COUNT;
      IF (TICKET_COUNT>0) THEN
        PRIZE_COST=SECOND_4_ROUND_SUM*(SUBROUND_PERCENT/100)/TICKET_COUNT;
      ELSE
        PRIZE_COST=NULL;
      COUNTER=0;

      FOR SELECT BARREL_NUM
             FROM LOTTERY
            WHERE TIRAGE_ID=:TIRAGE_ID
              AND ROUND_NUM=:ROUND_NUM
              AND SUBROUND_ID=:SUBROUND_ID
            ORDER BY PRIORITY
             INTO :BARREL_NUM DO BEGIN

        IF (COUNTER=0) THEN
          NUMBERS=BARREL_NUM;
        ELSE
          NUMBERS=NUMBERS||','||BARREL_NUM;

        COUNTER=COUNTER+1;

      END

      SUSPEND;
    END

  END

END

--

