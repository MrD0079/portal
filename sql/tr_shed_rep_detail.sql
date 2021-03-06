/* Formatted on 23.09.2013 16:22:15 (QP5 v5.227.12220.39724) */
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
         AND tb.head = th.id
         AND tr.id = th.tr
         AND tl.id = th.loc
         AND tb.completed = 1
         AND tb.test = 2
         AND th.id = :id
         AND (tbu.tn IN (SELECT slave
                           FROM full
                          WHERE master = :tn))
ORDER BY tr_name,
         th.dt_start,
         coach_fio,
         participant_pos_name,
         participant_fio