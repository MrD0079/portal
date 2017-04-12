/* Formatted on 12.04.2017 12:37:34 (QP5 v5.252.13127.32867) */
  SELECT rh.*,
         fn_getname (rh.tn) fio,
         rp.name pos,
         DECODE (svmsok.id, NULL, 0, 1) svmsok
    FROM routes_head rh,
         routes_pos rp,
         (SELECT DISTINCT h.id
            FROM routes_head h,
                 routes_body1 b,
                 calendar c,
                 merch_report mr,
                 merch_report_ok o
           WHERE     h.id = b.head_id
                 AND h.data = TRUNC (c.data, 'mm')
                 AND c.dm = b.day_num
                 AND b.id = mr.rb_id
                 AND c.data = mr.dt
                 AND h.id = o.head_id
                 AND c.data = o.dt) svmsok
   WHERE     data = TO_DATE ( :month_list, 'dd.mm.yyyy')
         AND tn IN (SELECT slave
                      FROM full
                     WHERE master = :tn)
         AND rh.pos_otv = rp.id(+)
         AND rh.id = svmsok.id(+)
ORDER BY fio, rh.num, pos