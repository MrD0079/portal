/* Formatted on 13/09/2013 14:30:36 (QP5 v5.227.12220.39724) */
  SELECT distinct u.h_eta,
         u.tab_num,
         u.fio,
         u.pos_name,
         u.pos_id,
         TO_CHAR (u.start_pos, 'dd/mm/yyyy') start_pos,
         TO_CHAR (u.start_company, 'dd/mm/yyyy') start_company,
         u.start_pos o_start_pos,
         u.start_company o_start_company,
         u.dpt_id,
         u.dpt_name,
         d.sort,
         t.o_max_dt_start_old,
         t.max_dt_start_old,
         t.o_max_dt_start_this_tr,
         t.max_dt_start_this_tr,
         t.tr_ok,
         this_tr.manual,
         this_tr.os
    FROM (  SELECT tob.h_eta,
                   MAX (toh.dt_start) o_max_dt_start_old,
                   TO_CHAR (MAX (toh.dt_start), 'dd/mm/yyyy') max_dt_start_old,
                   MAX (DECODE (toh.tr,
                                (SELECT tr
                                   FROM tr_pt_order_head
                                  WHERE id = :id), toh.dt_start,
                                NULL))
                      o_max_dt_start_this_tr,
                   TO_CHAR (MAX (DECODE (toh.tr,
                                         (SELECT tr
                                            FROM tr_pt_order_head
                                           WHERE id = :id), toh.dt_start,
                                         NULL)),
                            'dd/mm/yyyy')
                      max_dt_start_this_tr,
                   MAX (DECODE (toh.tr,
                                (SELECT tr
                                   FROM tr_pt_order_head
                                  WHERE id = :id), 1,
                                0))
                      tr_ok
              FROM tr_pt_order_head toh, tr_pt_order_body tob, user_list u
             WHERE     toh.id = tob.head
                   AND tob.manual >= 0
                   AND u.h_eta = tob.h_eta
                   AND toh.dt_start < (SELECT dt_start
                                         FROM tr_pt_order_head
                                        WHERE id = :id)
          GROUP BY tob.h_eta, u.dpt_id) t,
         user_list u,
         departments d,
         (SELECT tob.h_eta, tob.manual,tob.os
            FROM tr_pt_order_head toh, tr_pt_order_body tob
           WHERE toh.id = tob.head AND toh.id = :id AND tob.manual >= 0) this_tr
   WHERE     u.dpt_id = d.dpt_id
         AND u.h_eta = t.h_eta(+)
         AND u.h_eta = this_tr.h_eta
         AND u.is_eta = 1
         AND NVL (u.is_top, 0) <> 1
         AND u.dpt_id = :dpt_id
ORDER BY u.fio