/* Formatted on 19.04.2013 11:20:08 (QP5 v5.163.1008.3004) */
  SELECT mt || ' ' || y my, TO_CHAR (data, 'dd.mm.yyyy') dt
    FROM calendar c, (SELECT DISTINCT dt FROM w4u_pg) pg
   WHERE TRUNC (data, 'mm') = data AND data BETWEEN TO_DATE ('01.12.2012', 'dd.mm.yyyy') AND TO_DATE ('01.11.2013', 'dd.mm.yyyy') AND pg.dt = c.data
ORDER BY DATA