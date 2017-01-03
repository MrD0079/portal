/* Formatted on 03.01.2017 18:39:36 (QP5 v5.252.13127.32867) */
SELECT ROWNUM,
       z.*,
       CASE
          WHEN sd > ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -3) THEN 1
          ELSE 0
       END
          routes_enabled,
       DECODE (h.data, NULL, 0, 1) routes_exists,
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
        ORDER BY MIN (DATA)) z,
       (SELECT DISTINCT data FROM routes_head) h
 WHERE z.sd = h.data(+)