/* Formatted on 09.07.2013 9:59:29 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT TO_CHAR (t.m, 'dd.mm.yyyy') m,
                  TO_CHAR (t.dt, 'dd.mm.yyyy') data,
                  t.m m1,
                  t.dt data1,
                  c.mt,
                  c.y
    FROM w4u_transit1 t, calendar c
   WHERE c.data = t.m AND t.dt IS NOT NULL AND t.m IS NOT NULL
ORDER BY t.m, t.dt