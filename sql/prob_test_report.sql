/* Formatted on 05/04/2016 19:45:07 (QP5 v5.252.13127.32867) */
  SELECT p.*,
         DECODE (
            SIGN (
                 DECODE (SIGN (stamp_employee - stamp_chief),
                         1, stamp_employee,
                         stamp_chief)
               - stamp_teacher),
            1, DECODE (SIGN (stamp_employee - stamp_chief),
                       1, stamp_employee,
                       stamp_chief),
            stamp_teacher)
            ad_completed_date,
         TO_CHAR (p.test_lu, 'dd.mm.yyyy hh24:mi:ss') test_lu,
         u.fio,
         u1.fio fio_chief,
         (SELECT COUNT (*)
            FROM prob_test
           WHERE parent = p.test_id)
            max_ball,
         DECODE (NVL ( (SELECT COUNT (*)
                          FROM prob_test
                         WHERE parent = p.test_id),
                      0),
                 0, 0,
                   p.test_ball
                 / (SELECT COUNT (*)
                      FROM prob_test
                     WHERE parent = p.test_id)
                 * 100)
            perc
    FROM user_list u,
         p_plan p,
         parents pa,
         user_list u1
   WHERE     p.tn = u.tn
         AND pa.tn = p.tn
         AND u1.tn = pa.parent
         AND (   :exp_list_without_ts = 0
              OR u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :exp_list_without_ts))
         AND u.tn IN (SELECT slave
                        FROM full
                       WHERE master = :tn)
         AND p.test = 2
         AND DECODE (
                SIGN (
                     DECODE (SIGN (stamp_employee - stamp_chief),
                             1, stamp_employee,
                             stamp_chief)
                   - stamp_teacher),
                1, DECODE (SIGN (stamp_employee - stamp_chief),
                           1, stamp_employee,
                           stamp_chief),
                stamp_teacher) BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
         AND p.tn = DECODE ( :probs, 0, p.tn, :probs)
ORDER BY u.fio