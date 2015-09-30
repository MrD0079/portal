/* Formatted on 08.06.2012 11:14:25 (QP5 v5.163.1008.3004) */
SELECT ROWNUM, z.*
  FROM (  SELECT TO_CHAR (DATA, 'dd.mm.yyyy') DATA_C, c.*
            FROM calendar c
           WHERE data BETWEEN TRUNC (SYSDATE) - 3 AND TRUNC (SYSDATE) + 3
        ORDER BY DATA) z