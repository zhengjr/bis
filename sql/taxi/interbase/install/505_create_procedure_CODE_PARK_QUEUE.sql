/* �������� ��������� ������� ������ � ������� �� ������� */

CREATE PROCEDURE /*PREFIX*/CODE_PARK_QUEUE
(
  ACCOUNT_ID VARCHAR(32),
  IN_MESSAGE_ID VARCHAR(32)
)
AS
  DECLARE CONTACT VARCHAR(100);
  DECLARE SENDER_ID VARCHAR(32);
  DECLARE S VARCHAR(1000);
  DECLARE CNT INTEGER;
  DECLARE D TIMESTAMP;
  DECLARE DATE_IN TIMESTAMP;
  DECLARE DRIVER_ID VARCHAR(32);
  DECLARE PARK_NAME VARCHAR(100);
  DECLARE PARK_ID VARCHAR(32);
  DECLARE SUM_CHARGE NUMERIC(15,2);
  DECLARE SUM_RECEIPT NUMERIC(15,2);
  DECLARE BALANCE NUMERIC(15,2);
  DECLARE MIN_BALANCE NUMERIC(15,2);
  DECLARE MINUTES INTEGER;
  DECLARE COUNTER INTEGER;
  DECLARE PRIORITY INTEGER;
BEGIN
  SELECT CONTACT, SENDER_ID
    FROM /*PREFIX*/IN_MESSAGES
   WHERE IN_MESSAGE_ID=:IN_MESSAGE_ID
    INTO :CONTACT, :SENDER_ID;

  IF ((CONTACT IS NOT NULL) AND (SENDER_ID IS NOT NULL)) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/DRIVERS D
      JOIN /*PREFIX*/ ACCOUNTS A ON A.ACCOUNT_ID=D.DRIVER_ID
     WHERE D.DRIVER_ID=:SENDER_ID
       AND A.LOCKED<>1
      INTO :CNT;

    IF (CNT>0) THEN BEGIN

      SELECT (CASE WHEN SUM(SUM_CHARGE) IS NULL THEN 0.0 ELSE SUM(SUM_CHARGE) END)
        FROM /*PREFIX*/CHARGES
       WHERE ACCOUNT_ID=:SENDER_ID
        INTO :SUM_CHARGE;

      SELECT (CASE WHEN SUM(SUM_RECEIPT) IS NULL THEN 0.0 ELSE SUM(SUM_RECEIPT) END)
        FROM /*PREFIX*/RECEIPTS
       WHERE ACCOUNT_ID=:SENDER_ID
        INTO :SUM_RECEIPT;

      BALANCE=SUM_RECEIPT-SUM_CHARGE;

      SELECT MIN_BALANCE
        FROM /*PREFIX*/DRIVERS
       WHERE DRIVER_ID=:SENDER_ID
        INTO :MIN_BALANCE;

      IF ((MIN_BALANCE IS NULL) OR ((MIN_BALANCE IS NOT NULL) AND (BALANCE>MIN_BALANCE))) THEN BEGIN

        PARK_ID=NULL;
        PARK_NAME=NULL;

        FOR SELECT PS.PARK_ID, P.NAME
              FROM /*PREFIX*/PARK_STATES PS
              JOIN /*PREFIX*/PARKS P ON P.PARK_ID=PS.PARK_ID
             WHERE DRIVER_ID=:SENDER_ID
               AND DATE_OUT IS NULL
              INTO :PARK_ID, :PARK_NAME DO BEGIN
          BREAK;
        END

        IF (PARK_ID IS NOT NULL) THEN BEGIN

          D=NULL;
          COUNTER=0;

          FOR SELECT DATE_IN, DRIVER_ID
                FROM /*PREFIX*/PARK_STATES
               WHERE DATE_OUT IS NULL
                 AND PARK_ID=:PARK_ID
               ORDER BY DATE_IN
                INTO :DATE_IN, :DRIVER_ID DO BEGIN

            COUNTER=COUNTER+1;

            IF (DRIVER_ID=SENDER_ID) THEN BEGIN
              D=CURRENT_TIMESTAMP;
              MINUTES=CAST((D-DATE_IN)*(1e0*24*60) AS INTEGER);
              PRIORITY=COUNTER;
            END

          END

          IF (D IS NOT NULL) THEN BEGIN

            S='�� ������ �� ������� '||PARK_NAME||' ('||CAST(PRIORITY AS VARCHAR(10))||' �� '||CAST(COUNTER AS VARCHAR(10))||').';
            S=S||' ������������ = '||CAST(MINUTES AS VARCHAR(10))||' ���.';

            INSERT INTO /*PREFIX*/OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                                TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED)
                                        VALUES (/*PREFIX*/GET_UNIQUE_ID(),:ACCOUNT_ID,:SENDER_ID,CURRENT_TIMESTAMP,
                                                :S,NULL,0,:CONTACT,NULL,1,NULL);
          END

        END

      END

    END

  END
END

--

/* �������� ��������� */

COMMIT