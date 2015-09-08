/* Formatted on 22/08/2013 9:52:34 (QP5 v5.227.12220.39724) */
  SELECT t.h_fio_eta,
         t.fio_eta,
         t.tab_num,
         u.fio fio_ts,
         MIN (t.visible) visible
    FROM (SELECT DISTINCT tab_num,
                          fio_eta,
                          h_fio_eta,
                          dt m,
                          1 visible
            FROM w4u_pg
           WHERE tab_num <> 0
          UNION
          SELECT DISTINCT tab_num,
                          fio_eta,
                          h_fio_eta,
                          m,
                          visible
            FROM w4u_transit1
           WHERE tab_num <> 0) t,
         user_list u
   WHERE     t.tab_num = u.tab_num
         AND u.pos_id = 57
         AND u.dpt_id = :dpt_id
         AND t.m = TO_DATE (:dt, 'dd.mm.yyyy')
         AND t.fio_eta IS NOT NULL
GROUP BY t.h_fio_eta,
         t.fio_eta,
         t.tab_num,
         u.fio
ORDER BY t.fio_eta