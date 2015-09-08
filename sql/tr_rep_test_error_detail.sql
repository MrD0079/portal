/* Formatted on 01.08.2013 14:27:59 (QP5 v5.227.12220.39724) */
  SELECT loc_name,
         dt_start,
         coach_pos_name,
         coach_fio,
         participant_pos_name,
         participant_fio,
         q_name
    FROM (SELECT q.id_num q_id,
                 b.tn,
                 b.head,
                 q.name q_name,
                 q.num q_num,
                 dt_start dt_start_s,
                 TO_CHAR (h.dt_start, 'dd.mm.yyyy') dt_start,
                 tl.name loc_name,
                 thu.pos_name coach_pos_name,
                 thu.fio coach_fio,
                 tbu.pos_name participant_pos_name,
                 tbu.fio participant_fio
            FROM tr,
                 user_list tbu,
                 user_list thu,
                 tr_order_head h,
                 tr_order_body b,
                 tr_test_qa q,
                 tr_loc tl
           WHERE     b.manual >= 0
                 AND thu.tn = h.tn
                 AND tbu.tn = b.tn
                 AND tbu.dpt_id = :dpt_id
                 AND h.id = b.head
                 AND tl.id = h.loc
                 AND h.tr = :tr
                 AND h.tr = q.tr
                 AND tr.id = h.tr
                 AND q.TYPE = 5
                 AND b.test_count > 0
                 AND h.dt_start BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                    AND TO_DATE (:ed, 'dd.mm.yyyy')) q1,
         tr_order_test_res tr
   WHERE     q1.q_id = tr.q(+)
         AND q1.tn = tr.tn(+)
         AND q1.head = tr.head(+)
         AND q1.q_id = :q_id
         AND NVL (tr.ok, 0) <> 1
ORDER BY dt_start_s,
         loc_name,
         participant_pos_name,
         participant_fio