/* Formatted on 29.05.2017 16:58:49 (QP5 v5.252.13127.32867) */
  SELECT c.*, t.hours, vac.working_hours
    FROM calendar c,
         ms_tabel_days t,
         routes_head h,
         (SELECT c.data, sm.working_hours
            FROM calendar c,
                 ms_vac mv,
                 routes_head h,
                 spr_users_ms sm
           WHERE     mv.login = h.login
                 AND mv.login = sm.login
                 AND mv.removed IS NULL
                 AND h.id = :head_id
                 AND c.data BETWEEN mv.vac_start AND mv.vac_start + mv.days - 1)
         vac
   WHERE     TRUNC (c.data, 'mm') = h.data
         AND h.id = :head_id
         AND c.dm = t.day_num(+)
         AND t.head_id(+) = :head_id
         AND c.data = vac.data(+)
ORDER BY c.data