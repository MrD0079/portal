/* Formatted on 13/09/2013 16:45:51 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (c.data, 'dd.mm.yyyy') dt_start_t,
         h.id,
         h.lu,
         h.tn,
         h.tr,
         h.loc,
         h.text,
         h.ok_primary,
         h.ok_final,
         u.fio,
         tr.name,
         l.name loc_name,
         (SELECT COUNT (*)
            FROM tr_pt_order_body
           WHERE head = h.id AND manual >= 0)
            stud_cnt,
         (SELECT COUNT (*)
            FROM tr_order_body
           WHERE head = h.id AND manual >= 0 AND completed = 1 AND test = 2)
            stud_cnt_ok,
         u.e_mail,
         TO_CHAR (SYSDATE + 2, 'dd/mm/yyyy hh24:mi') warn48,
         TO_CHAR (h.dt_start, 'dd/mm/yyyy') tr_pt_start,
         TO_CHAR (h.dt_start + tr.days - 1, 'dd/mm/yyyy') tr_pt_end,
         ub.h_eta st_tn,
         ub.fio st_fio,
         ub.pos_name st_pos
    FROM tr_pt_order_head h,
         user_list u,
         tr,
         tr_loc l,
         tr_pt_order_body b,
         user_list ub,
         calendar c,
         parents_eta pe
   WHERE     h.ok_final = 1
         AND b.head = h.id
         AND b.manual >= 0
         AND u.tn = h.tn
         AND ub.h_eta = b.h_eta
         AND tr.id = h.tr
         AND h.loc = l.id
         AND TRUNC (h.dt_start, 'mm') = TO_DATE (:sd, 'dd.mm.yyyy')
         AND pe.h_eta = b.h_eta
         AND ub.dpt_id = pe.dpt_id
         AND (   pe.chief_tn IN
                    (SELECT slave
                       FROM full
                      WHERE     master = :tn
                            AND full =
                                   DECODE (:tr_pt_flt,
                                           1, -2,
                                           2, 1,
                                           3, 0,
                                           4, full))
              OR u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn))
         AND c.data BETWEEN h.dt_start AND h.dt_start + days - 1
ORDER BY h.dt_start, ub.fio