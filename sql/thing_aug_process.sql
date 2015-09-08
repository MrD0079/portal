/* Formatted on 11.01.2013 13:45:15 (QP5 v5.163.1008.3004) */
  SELECT z1.*,
         b1 + b2 + b3 + b4 bt,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = z1.tn))
            parent_fio
    FROM (SELECT z.*,
                 TRUNC (
                    DECODE (SIGN (DECODE (SIGN (d1 / 5 - 4), 1, d1 / 5 - 4, 0) - 1),
                            -1, 0,
                            DECODE (SIGN (8 - DECODE (SIGN (d1 / 5 - 4), 1, d1 / 5 - 4, 0)), -1, 8, DECODE (SIGN (d1 / 5 - 4), 1, d1 / 5 - 4, 0))))
                    b1,
                 TRUNC (
                    DECODE (SIGN (DECODE (SIGN (d2 / 5 - 4), 1, d2 / 5 - 4, 0) - 1),
                            -1, 0,
                            DECODE (SIGN (8 - DECODE (SIGN (d2 / 5 - 4), 1, d2 / 5 - 4, 0)), -1, 8, DECODE (SIGN (d2 / 5 - 4), 1, d2 / 5 - 4, 0))))
                    b2,
                 TRUNC (
                    DECODE (SIGN (DECODE (SIGN (d3 / 5 - 4), 1, d3 / 5 - 4, 0) - 1),
                            -1, 0,
                            DECODE (SIGN (8 - DECODE (SIGN (d3 / 5 - 4), 1, d3 / 5 - 4, 0)), -1, 8, DECODE (SIGN (d3 / 5 - 4), 1, d3 / 5 - 4, 0))))
                    b3,
                 TRUNC (
                    DECODE (SIGN (DECODE (SIGN (d4 / 5 - 4), 1, d4 / 5 - 4, 0) - 1),
                            -1, 0,
                            DECODE (SIGN (8 - DECODE (SIGN (d4 / 5 - 4), 1, d4 / 5 - 4, 0)), -1, 8, DECODE (SIGN (d4 / 5 - 4), 1, d4 / 5 - 4, 0))))
                    b4
            FROM (SELECT u.fio,
                         t.*,
                         DECODE (NVL (akb, 0), 0, 0, s1 / akb) * 100 d1,
                         DECODE (NVL (akb, 0), 0, 0, s2 / akb) * 100 d2,
                         DECODE (NVL (akb, 0), 0, 0, s3 / akb) * 100 d3,
                         DECODE (NVL (akb, 0), 0, 0, s4 / akb) * 100 d4,
                         u.tn
                    FROM (  SELECT fio_eta,
                                   tab_num,
                                   SUM (akb) akb,
                                   SUM (s1) s1,
                                   SUM (s2) s2,
                                   SUM (s3) s3,
                                   SUM (s4) s4
                              FROM AKC_SHTUCHKA_aug
                          GROUP BY fio_eta, tab_num) t,
                         user_list u
                   WHERE     u.tab_num = t.tab_num
                         AND u.dpt_id = :dpt_id
                         AND (u.tn IN (SELECT emp_tn
                                         FROM (    SELECT                                                                                           /*LPAD (z.EXP, LENGTH (z.EXP) + (LEVEL) * 3, '-'),*/
                                                         LPAD (z.emp, LENGTH (z.emp) + (LEVEL) * 3, '-'), LEVEL, z.*
                                                     FROM (SELECT fn_getname ( exp_tn) EXP,
                                                                  fn_getname ( emp_tn) emp,
                                                                  exp_tn,
                                                                  emp_tn,
                                                                  full
                                                             FROM emp_exp
                                                            WHERE full = 1 AND exp_tn <> emp_tn) z
                                               START WITH exp_tn = DECODE (:thing_ts_list,
                                                                           0, DECODE (:thing_chief_list,
                                                                                      0, DECODE ( (SELECT NVL (is_super, 0) + NVL (is_traid, 0)
                                                                                                     FROM user_list
                                                                                                    WHERE tn = :tn),
                                                                                                 0, :tn,
                                                                                                 2923402273),
                                                                                      :thing_chief_list),
                                                                           0)
                                               CONNECT BY PRIOR emp_tn = exp_tn)
                                       UNION
                                       SELECT :tn FROM DUAL
                                       UNION
                                       SELECT DECODE (:thing_ts_list, 0, 0, :thing_ts_list) FROM DUAL))
                         AND u.tab_num <> 0) z) z1
ORDER BY parent_fio, fio, fio_eta