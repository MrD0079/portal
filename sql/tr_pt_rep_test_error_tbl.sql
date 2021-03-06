/* Formatted on 17.09.2013 12:41:45 (QP5 v5.227.12220.39724) */
  SELECT q_id,
         q_name,
         SUM (DECODE (NVL (tr.ok, 0), 0, 1, 0)) q_bad_cnt,
         COUNT (*) q_all_cnt,
         DECODE (
            COUNT (*),
            0, 0,
            ROUND (SUM (DECODE (NVL (tr.ok, 0), 0, 1, 0)) / COUNT (*) * 100, 2))
            perc_bad,
         q_num
    FROM (SELECT q.id_num q_id,
                 b.h_eta,
                 b.head,
                 q.name q_name,
                 q.num q_num
            FROM user_list tbu,
                 tr_pt_order_head h,
                 tr_pt_order_body b,
                 tr_test_qa q
           WHERE     b.manual >= 0
                 AND tbu.h_eta = b.h_eta
                 AND tbu.dpt_id = :dpt_id
                 AND h.id = b.head
                 AND h.tr = :tr
                 AND h.tr = q.tr
                 AND q.TYPE = 5
                 AND b.test_count > 0
                 AND h.dt_start BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                    AND TO_DATE (:ed, 'dd.mm.yyyy')) q1,
         tr_pt_order_test_res tr
   WHERE q1.q_id = tr.q(+) AND q1.h_eta = tr.h_eta(+) AND q1.head = tr.head(+)
GROUP BY q_id, q_name, q_num
ORDER BY perc_bad DESC, q_name