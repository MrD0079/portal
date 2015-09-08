/* Formatted on 26.03.2013 14:45:48 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT TO_CHAR (TRUNC (c.data, 'q'), 'dd.mm.yyyy') dt_q,
                  TO_CHAR (TRUNC (c.data, 'mm'), 'dd.mm.yyyy') dt_m,
                  c.my m,
                  c.mt,
                  c.q,
                  c.y
    FROM calendar c
   WHERE c.data BETWEEN (SELECT MIN (m) FROM w4u_vp1) AND (SELECT MAX (m) FROM w4u_vp1)
ORDER BY c.y, c.q, c.my