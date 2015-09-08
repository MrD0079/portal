/* Formatted on 13/09/2013 16:38:08 (QP5 v5.227.12220.39724) */
  SELECT COUNT (DISTINCT h_eta) tn, full
    FROM (SELECT b.h_eta,
                 (SELECT full
                    FROM full
                   WHERE master = :tn AND slave = pe.chief_tn)
                    full
            FROM tr_pt_order_head h,
                 tr_pt_order_body b,
                 parents_eta pe,
                 user_list u
           WHERE     h.dt_start >= TRUNC (SYSDATE)
                 AND h.id = b.head
                 AND b.manual >= 0
                 AND h.ok_final = 1
                 AND pe.chief_tn IN (SELECT slave
                                       FROM full
                                      WHERE master = :tn)
                 AND u.h_eta = b.h_eta
                 AND b.h_eta = pe.h_eta
                 AND u.dpt_id = pe.dpt_id)
GROUP BY full