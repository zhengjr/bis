CREATE OR ALTER PROCEDURE GET_COUNT_OUT_MESSAGES_REPORT (DATE_BEGIN Date,
       DATE_END   Date,
       CONTACT    Varchar(20))
returns (DATE_OUT       TIMESTAMP,
         WEEK_DAY_NAME  Varchar(20),
         DATE_YEAR_DAY  Integer,
         DATE_WEEKDAY   Integer,
         HOUR_01        Integer,
         HOUR_02        Integer,
         HOUR_03        Integer,
         HOUR_04        Integer,
         HOUR_05        Integer,
         HOUR_06        Integer,
         HOUR_07        Integer,
         HOUR_08        Integer,
         HOUR_09        Integer,
         HOUR_10        Integer,
         HOUR_11        Integer,
         HOUR_12        Integer,
         HOUR_13        Integer,
         HOUR_14        Integer,
         HOUR_15        Integer,
         HOUR_16        Integer,
         HOUR_17        Integer,
         HOUR_18        Integer,
         HOUR_19        Integer,
         HOUR_20        Integer,
         HOUR_21        Integer,
         HOUR_22        Integer,
         HOUR_23        Integer,
         HOUR_24        Integer,
         COUNT_TO_DAY   Integer,
         DATE_MONTH     Integer,
         DATE_YEAR      Integer,
         CONTACT_R      Varchar(20),
         USER_NAME      Varchar(100),
         FIRST_YEAR_DAY Integer)
AS 

begin
FOR
 SELECT MIN(GCO.DATE_OUT) AS DATE_OUT,
        GCO.DATE_YEAR_DAY,
        GCO.DATE_WEEKDAY,
        MIN(GCO.DATE_MONTH) AS DATE_MONTH,
        MIN(GCO.DATE_YEAR) AS DATE_YEAR,          
        MIN(GCO.CONTACT_R) AS CONTACT_R,
        MIN(A.USER_NAME) AS USER_NAME,
        MIN(EXTRACT(WEEKDAY FROM CAST(('01.01.'||EXTRACT(YEAR FROM GCO.DATE_OUT)) AS DATE)) - 1) AS FIRST_YEAR_DAY,                
       (CASE 
             WHEN GCO.DATE_WEEKDAY = 1 THEN '��'
             WHEN GCO.DATE_WEEKDAY = 2 THEN '��'
             WHEN GCO.DATE_WEEKDAY = 3 THEN '��'
             WHEN GCO.DATE_WEEKDAY = 4 THEN '��'
             WHEN GCO.DATE_WEEKDAY = 5 THEN '��'
             WHEN GCO.DATE_WEEKDAY = 6 THEN '��'
             WHEN GCO.DATE_WEEKDAY = 7 THEN '��'
       ELSE '' END) AS WEEK_DAY_NAME,
       MAX(GCO.HOUR_01) AS HOUR_01,
       MAX(GCO.HOUR_02) AS HOUR_02,
       MAX(GCO.HOUR_03) AS HOUR_03,
       MAX(GCO.HOUR_04) AS HOUR_04,
       MAX(GCO.HOUR_05) AS HOUR_05,
       MAX(GCO.HOUR_06) AS HOUR_06,
       MAX(GCO.HOUR_07) AS HOUR_07,
       MAX(GCO.HOUR_08) AS HOUR_08,
       MAX(GCO.HOUR_09) AS HOUR_09,
       MAX(GCO.HOUR_10) AS HOUR_10,
       MAX(GCO.HOUR_11) AS HOUR_11,
       MAX(GCO.HOUR_12) AS HOUR_12,
       MAX(GCO.HOUR_13) AS HOUR_13,
       MAX(GCO.HOUR_14) AS HOUR_14,
       MAX(GCO.HOUR_15) AS HOUR_15,
       MAX(GCO.HOUR_16) AS HOUR_16,
       MAX(GCO.HOUR_17) AS HOUR_17,
       MAX(GCO.HOUR_18) AS HOUR_18,
       MAX(GCO.HOUR_19) AS HOUR_19,
       MAX(GCO.HOUR_20) AS HOUR_20,
       MAX(GCO.HOUR_21) AS HOUR_21,
       MAX(GCO.HOUR_22) AS HOUR_22,
       MAX(GCO.HOUR_23) AS HOUR_23,
       MAX(GCO.HOUR_24) AS HOUR_24,
       SUM(GCO.COUNT_TO_DAY) AS COUNT_TO_DAY
               
FROM GET_COUNT_OUT_MESSAGES(:DATE_BEGIN, :DATE_END, :CONTACT) GCO
LEFT JOIN ACCOUNTS A ON A.PHONE = GCO.CONTACT_R
GROUP BY GCO.CONTACT_R , GCO.DATE_YEAR_DAY, GCO.DATE_WEEKDAY
ORDER BY MIN(A.USER_NAME), MIN(GCO.DATE_OUT)
            INTO :DATE_OUT, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,
             :DATE_MONTH,
             :DATE_YEAR,             
             :CONTACT_R,
             :USER_NAME,
             :FIRST_YEAR_DAY,
             :WEEK_DAY_NAME,
             :HOUR_01       ,
         :HOUR_02       ,
         :HOUR_03       ,
         :HOUR_04       ,
         :HOUR_05       ,
         :HOUR_06       ,
         :HOUR_07       ,
         :HOUR_08       ,
         :HOUR_09       ,
         :HOUR_10       ,
         :HOUR_11       ,
         :HOUR_12       ,
         :HOUR_13       ,
         :HOUR_14       ,
         :HOUR_15       ,
         :HOUR_16       ,
         :HOUR_17       ,
         :HOUR_18       ,
         :HOUR_19       ,
         :HOUR_20       ,
         :HOUR_21       ,
         :HOUR_22       ,
         :HOUR_23       ,
         :HOUR_24,
         :COUNT_TO_DAY 
         DO BEGIN
    SUSPEND;
  END
end