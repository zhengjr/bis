/* �������� ��������� ��������� ��������� ��� ������� */

CREATE VIEW /*PREFIX*/S_DRIVER_PARK_FREE
AS
SELECT *
  FROM S_DRIVERS
 WHERE DRIVER_ID IN (SELECT ACCOUNT_ID FROM SHIFTS
                      WHERE DATE_END IS NULL)
   AND DRIVER_ID NOT IN (SELECT DRIVER_ID FROM PARK_STATES
                          WHERE DATE_OUT IS NULL)
   AND LOCKED=0
   AND ((MIN_BALANCE IS NULL) OR (ACTUAL_BALANCE>MIN_BALANCE))

--

/* �������� ��������� */

COMMIT