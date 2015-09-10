/* Formatted on 16.06.2014 16:08:32 (QP5 v5.227.12220.39724) */
  SELECT u.tn,
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
    FROM (  SELECT tob.tn,
                   MAX (toh.dt_start) o_max_dt_start_old,
                   TO_CHAR (MAX (toh.dt_start), 'dd/mm/yyyy') max_dt_start_old,
                   MAX (DECODE (toh.tr,
                                (SELECT tr
                                   FROM tr_order_head
                                  WHERE id = :id), toh.dt_start,
                                NULL))
                      o_max_dt_start_this_tr,
                   TO_CHAR (MAX (DECODE (toh.tr,
                                         (SELECT tr
                                            FROM tr_order_head
                                           WHERE id = :id), toh.dt_start,
                                         NULL)),
                            'dd/mm/yyyy')
                      max_dt_start_this_tr,
                   MAX (DECODE (toh.tr,
                                (SELECT tr
                                   FROM tr_order_head
                                  WHERE id = :id), 1,
                                0))
                      tr_ok,
                     ABS (  (SELECT dt_start
                               FROM tr_order_head
                              WHERE id = :id)
                          - NVL (MAX (toh.dt_start), SYSDATE - 1000))
                   - (SELECT val_number
                        FROM parameters
                       WHERE     param_name = 'tr_order_users_list_manual'
                             AND dpt_id = u.dpt_id)
                      f2
              FROM tr_order_head toh, tr_order_body tob, user_list u
             WHERE toh.id = tob.head AND tob.manual >= 0 AND u.tn = tob.tn
          GROUP BY tob.tn, u.dpt_id) t,
         user_list u,
         departments d
   WHERE     u.dpt_id = d.dpt_id
         AND u.tn = t.tn(+)
         AND u.is_spd = 1
         AND NVL (u.is_top, 0) <> 1
         AND u.datauvol IS NULL
         AND NVL (f2, 0) >= 0
         /*AND u.dpt_id = :dpt_id*/
         AND (SELECT DECODE (COUNT (c1.data), 0, 0, 1)
                FROM vacation v, calendar c1
               WHERE     NVL (
                            (SELECT accepted
                               FROM sz_accept
                              WHERE     sz_id = v.sz_id
                                    AND accept_order =
                                           DECODE (
                                              NVL (
                                                 (SELECT accept_order
                                                    FROM sz_accept
                                                   WHERE     sz_id = v.sz_id
                                                         AND accepted = 2),
                                                 0),
                                              0, (SELECT MAX (accept_order)
                                                    FROM sz_accept
                                                   WHERE sz_id = v.sz_id),
                                              (SELECT accept_order
                                                 FROM sz_accept
                                                WHERE     sz_id = v.sz_id
                                                      AND accepted = 2))),
                            0) = 1
                     AND c1.data BETWEEN v.v_from AND v.v_to
                     AND v.tn = u.tn
                     AND (SELECT dt_start
                            FROM tr_order_head
                           WHERE id = :id) = c1.data) = 0
ORDER BY d.sort, u.fio