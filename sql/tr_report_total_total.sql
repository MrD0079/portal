/* Formatted on 23/06/2015 13:32:34 (QP5 v5.227.12220.39724) */
SELECT SUM (h.completed) completed,
       SUM ( (SELECT NVL (COUNT (*), 0)
                FROM tr_order_body
               WHERE head = h.id AND manual >= 0))
          stud_cnt,
       SUM ( (SELECT NVL (COUNT (*), 0)
                FROM tr_order_body
               WHERE head = h.id AND manual >= 0 AND completed = 1))
          stud_cnt_fakt,
       SUM (
          (SELECT NVL (COUNT (*), 0)
             FROM tr_order_body
            WHERE head = h.id AND manual >= 0 AND completed = 1 AND test = 2))
          stud_cnt_test_ok,
       SUM (
          DECODE (
             h.completed,
             1, (SELECT SUM (test_ball)
                   FROM tr_order_body
                  WHERE     head = h.id
                        AND manual >= 0
                        AND completed = 1
                        AND test = 2),
             0))
          test_ball,
       SUM (
            (SELECT NVL (COUNT (*), 0)
               FROM tr_test_qa qa
              WHERE qa.TYPE = 5 AND qa.tr = tr.id)
          * (SELECT NVL (COUNT (*), 0)
               FROM tr_order_body
              WHERE     head = h.id
                    AND manual >= 0
                    AND completed = 1
                    AND test = 2))
          max_ball,
       DECODE (
          SUM (
               (SELECT NVL (COUNT (*), 0)
                  FROM tr_test_qa qa
                 WHERE qa.TYPE = 5 AND qa.tr = tr.id)
             * (SELECT NVL (COUNT (*), 0)
                  FROM tr_order_body
                 WHERE     head = h.id
                       AND manual >= 0
                       AND completed = 1
                       AND test = 2)),
          0, 0,
            SUM (
               DECODE (
                  h.completed,
                  1, (SELECT SUM (test_ball)
                        FROM tr_order_body
                       WHERE     head = h.id
                             AND manual >= 0
                             AND completed = 1
                             AND test = 2),
                  0))
          / SUM (
                 (SELECT NVL (COUNT (*), 0)
                    FROM tr_test_qa qa
                   WHERE qa.TYPE = 5 AND qa.tr = tr.id)
               * (SELECT NVL (COUNT (*), 0)
                    FROM tr_order_body
                   WHERE     head = h.id
                         AND manual >= 0
                         AND completed = 1
                         AND test = 2))
          * 100)
          perc
  FROM tr_order_head h,
       user_list u,
       tr,
       tr_loc l,
       (SELECT DISTINCT slave
          FROM full
         WHERE    master = :tn
               OR (SELECT NVL (is_test_admin, 0)
                     FROM user_list
                    WHERE tn = :tn) = 1) w
 WHERE     TRUNC (h.dt_start, 'mm') BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                                        AND TO_DATE (:ed, 'dd/mm/yyyy')
       AND u.tn = h.tn
       AND tr.id = h.tr
       AND h.loc = l.id
       AND DECODE (:tr_tn, 0, h.tn, :tr_tn) = h.tn
       AND DECODE (:tr, 0, h.tr, :tr) = h.tr
       AND DECODE (:completed,  1, h.completed,  2, 1,  3, 0) = h.completed
       AND h.ok_primary = 1
       AND u.tn = w.slave