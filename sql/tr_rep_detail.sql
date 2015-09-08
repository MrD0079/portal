/* Formatted on 31/07/2013 16:53:10 (QP5 v5.227.12220.39724) */
  SELECT tr.name tr_name,
         TO_CHAR (th.dt_start, 'dd.mm.yyyy') dt_start,
         tl.name loc_name,
         thu.pos_name coach_pos_name,
         thu.fio coach_fio,
         tb.os,
         tbu.pos_name participant_pos_name,
         tbu.fio participant_fio,
         TO_CHAR (tb.test_lu, 'dd.mm.yyyy hh24:mi:ss') test_lu,
         tb.test_ball,
         (SELECT NVL (COUNT (*), 0)
            FROM tr_test_qa qa
           WHERE qa.TYPE = 5 AND qa.tr = tr.id)
            test_max,
         DECODE ( (SELECT NVL (COUNT (*), 0)
                     FROM tr_test_qa qa
                    WHERE qa.TYPE = 5 AND qa.tr = tr.id),
                 0, 0,
                 ROUND (  tb.test_ball
                        / (SELECT NVL (COUNT (*), 0)
                             FROM tr_test_qa qa
                            WHERE qa.TYPE = 5 AND qa.tr = tr.id)
                        * 100,
                        2))
            test_perc,
         NVL ( (SELECT MAX (ball)
                  FROM tr_order_test_history
                 WHERE head = tb.head AND tn = tb.tn),
              0)
            max_ball
    FROM tr,
         tr_order_head th,
         tr_order_body tb,
         user_list tbu,
         user_list thu,
         tr_loc tl
   WHERE     tb.manual >= 0
         AND thu.tn = th.tn
         AND tbu.tn = tb.tn
         AND tbu.dpt_id = :dpt_id
         AND tb.head = th.id
         AND tr.id = th.tr
         AND th.dt_start BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                             AND TO_DATE (:ed, 'dd.mm.yyyy')
         AND tl.id = th.loc
         AND tr.id IN (:tr)
         AND tbu.pos_id IN (:pos)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', tbu.region_name)
         AND DECODE (:department_name, '0', '0', :department_name) =
                DECODE (:department_name, '0', '0', tbu.department_name)
ORDER BY tr_name,
         th.dt_start,
         coach_fio,
         participant_pos_name,
         participant_fio