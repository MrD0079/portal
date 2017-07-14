/* Formatted on 13/09/2013 14:30:54 (QP5 v5.227.12220.39724) */
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
         t.tr_ok
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
                      tr_ok,
                     ABS (  (SELECT dt_start
                               FROM tr_pt_order_head
                              WHERE id = :id)
                          - NVL (MAX (toh.dt_start), SYSDATE - 1000))
                   - (SELECT val_number
                        FROM parameters
                       WHERE     param_name = 'tr_pt_order_users_list_manual'
                             AND dpt_id = u.dpt_id)
                      f2
              FROM tr_pt_order_head toh, tr_pt_order_body tob, user_list u
             WHERE toh.id = tob.head AND tob.manual >= 0 AND u.h_eta = tob.h_eta
          GROUP BY tob.h_eta, u.dpt_id) t,
         user_list u,
         departments d
   WHERE     u.dpt_id = d.dpt_id
         AND u.h_eta = t.h_eta(+)
         AND u.is_eta = 1
         AND NVL (u.is_top, 0) <> 1
         AND u.datauvol IS NULL
         AND NVL (f2, 0) >= 0
         AND u.dpt_id = :dpt_id
         AND (u.h_eta = :h_eta OR :h_eta = '0')
ORDER BY d.sort, u.fio