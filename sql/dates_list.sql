/* Formatted on 2011/04/22 11:53 (Formatter Plus v4.8.8) */
SELECT ROWNUM,
       z.*
  FROM (SELECT   TO_CHAR(DATA, 'dd.mm.yyyy') DATA_C
            FROM calendar c
        ORDER BY DATA) z