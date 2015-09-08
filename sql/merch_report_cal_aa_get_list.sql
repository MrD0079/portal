/* Formatted on 14/08/2015 21:20:16 (QP5 v5.227.12220.39724) */
  SELECT h.*,
         TO_CHAR (h.dts, 'dd.mm.yyyy') dts,
         TO_CHAR (h.dte, 'dd.mm.yyyy') dte,
         ch.city,
         n.net_name,
         a.name ag_name,
         fn_query2str (
               'SELECT DISTINCT c.tz_oblast
            FROM merch_report_cal_aa_o o, cpp c
           WHERE o.head_id = '
            || h.id
            || ' AND c.h_tz_oblast = o.h_o order by c.tz_oblast',
            ', ')
            obl
    FROM merch_report_cal_aa_h h,
         (  SELECT DISTINCT h_city, city
              FROM cpp
             WHERE city IS NOT NULL
          ORDER BY city) ch,
         ms_nets n,
         routes_agents a
   WHERE     h.h_city = ch.h_city(+)
         AND h.id_net = n.id_net(+)
         AND h.ag_id = a.id(+)
         AND DECODE (:ag_id, 0, NVL (h.ag_id, 0), :ag_id) = NVL (h.ag_id, 0)
         AND (   (:dt = 1 AND TRUNC (SYSDATE) BETWEEN h.dts AND h.dte)
              OR (:dt = 2 AND TRUNC (SYSDATE) > h.dte)
              OR :dt = 3)
ORDER BY h.id