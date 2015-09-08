/* Formatted on 29.03.2013 16:13:51 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT TO_CHAR (t.m, 'dd.mm.yyyy') m,
                  TO_CHAR (t.data, 'dd.mm.yyyy') data,
                  t.m m1,
                  t.data data1,
                  c.mt,
                  c.y
    FROM w4u_transit t, calendar c
   WHERE c.data = t.m
ORDER BY t.m, t.data
