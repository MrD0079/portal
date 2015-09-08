/* Formatted on 05/08/2015 19:54:01 (QP5 v5.227.12220.39724) */
SELECT ROWNUM,
       z.*,
       CASE
          WHEN sd > ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -3) THEN 1
          ELSE 0
       END
          routes_enabled,
       CASE
          WHEN sd > ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -2) THEN 1
          ELSE 0
       END
          ms_agenda_enabled,
       CASE
          WHEN sd > ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -2) THEN 1
          ELSE 0
       END
          ms_sku_visit_enabled,
       CASE WHEN sd >= TO_DATE ('01.01.2014', 'dd.mm.yyyy') THEN 1 ELSE 0 END
          acts_enabled,
       CASE WHEN sd >= TRUNC (SYSDATE, 'mm') THEN 1 ELSE 0 END
          merch_report_cal_enabled
  FROM (  SELECT mt || ' ' || y my,
                 TO_CHAR (MIN (DATA), 'dd.mm.yyyy') sd_c,
                 TO_CHAR (MAX (DATA), 'dd.mm.yyyy') ed_c,
                 MIN (DATA) sd
            FROM calendar c
        GROUP BY mt, y
        ORDER BY MIN (DATA)) z
        