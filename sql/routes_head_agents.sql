/* Formatted on 12.04.2017 12:04:53 (QP5 v5.252.13127.32867) */
  SELECT a.*,
         DECODE (ha.id, NULL, 0, 1) checked,
         DECODE (svmsok.id, NULL, 0, 1) svmsok
    FROM routes_head_agents ha,
         routes_agents a,
         (SELECT DISTINCT a.id
            FROM routes_head h,
                 routes_body1 b,
                 calendar c,
                 merch_report mr,
                 merch_report_ok o,
                 routes_agents a
           WHERE     h.id = b.head_id
                 AND h.data = TRUNC (c.data, 'mm')
                 AND c.dm = b.day_num
                 AND b.id = mr.rb_id
                 AND c.data = mr.dt
                 AND h.id = o.head_id
                 AND c.data = o.dt
                 AND a.id = b.ag_id
                 AND h.id = :route) svmsok
   WHERE     hA.HEAD_ID(+) = :route
         AND A.ID = HA.AG_ID(+)
         AND ha.vv(+) = 0
         AND a.id = svmsok.id(+)
ORDER BY a.name