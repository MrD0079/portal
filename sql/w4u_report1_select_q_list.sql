/* Formatted on 19.04.2013 13:38:58 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT TO_CHAR (TRUNC (c.data, 'q'), 'dd.mm.yyyy') dt, c.q, c.y
    FROM calendar c
   WHERE c.data BETWEEN (SELECT MIN (m) FROM w4u_vp1) AND (SELECT MAX (m) FROM w4u_vp1)
ORDER BY c.y, c.q