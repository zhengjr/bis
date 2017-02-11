/* �������� ��������� ������� ������� � ����������� */

CREATE VIEW /*PREFIX*/S_TASK_FIRMS
AS
   SELECT T.TASK_ID,
          D.DEAL_ID,
          DB.DEBTOR_ID,
          A.ACTION_ID,
          AR.AGREEMENT_ID,
          F.FIRM_ID,
          V.VARIANT_ID,
          C.CURRENCY_ID, 
          T.ACCOUNT_ID,
          A.NAME AS ACTION_NAME,
          A.PURPOSE,
          T.DATE_CREATE,
          T.DATE_BEGIN,
          D.DEAL_NUM,
          D.ACCOUNT_NUM,
          D.ARREAR_PERIOD,
          D.INITIAL_DEBT,
          D.DEBTOR_NUM,
          D.DEBTOR_DATE,
          D.GROUP_ID,
          F.SMALL_NAME AS FIRM_SMALL_NAME,
          DB.SURNAME,
          DB.NAME,
          DB.PATRONYMIC,
          C.NAME AS CURRENCY_NAME,
          (CASE  
             WHEN P1.AMOUNT IS NULL THEN D.INITIAL_DEBT
             ELSE D.INITIAL_DEBT-P1.AMOUNT
           END) AS CURRENT_DEBT,
          (SELECT TOP 1
                  R3.NAME AS LAST_RESULT_NAME
             FROM /*PREFIX*/TASKS T3
             JOIN /*PREFIX*/RESULTS R3 ON R3.RESULT_ID=T3.RESULT_ID
            WHERE T3.DEAL_ID=D.DEAL_ID
              AND T3.DATE_END IS NOT NULL
            ORDER BY T3.DATE_END DESC) AS LAST_RESULT_NAME
     FROM /*PREFIX*/TASKS T
     JOIN /*PREFIX*/DEALS D ON D.DEAL_ID=T.DEAL_ID 
     JOIN /*PREFIX*/ACTIONS A ON A.ACTION_ID=T.ACTION_ID
     JOIN /*PREFIX*/DEBTORS DB ON DB.DEBTOR_ID=D.DEBTOR_ID
     JOIN /*PREFIX*/AGREEMENTS AR ON AR.AGREEMENT_ID=D.AGREEMENT_ID
     JOIN /*PREFIX*/FIRMS F ON F.FIRM_ID=AR.FIRM_ID
     JOIN /*PREFIX*/VARIANTS V ON V.VARIANT_ID=AR.VARIANT_ID
     JOIN /*PREFIX*/CURRENCY C ON C.CURRENCY_ID=V.CURRENCY_ID
     LEFT JOIN (SELECT DEAL_ID, SUM(AMOUNT) AS AMOUNT 
                  FROM /*PREFIX*/PAYMENTS WHERE STATE=1
                 GROUP BY DEAL_ID)AS P1 ON P1.DEAL_ID=D.DEAL_ID    
    WHERE T.RESULT_ID IS NULL
     
--
