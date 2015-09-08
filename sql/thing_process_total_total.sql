/* Formatted on 11.01.2013 13:48:30 (QP5 v5.163.1008.3004) */
SELECT SUM (akb) akb,
       SUM (s1) s1,
       SUM (s2) s2,
       SUM (s3) s3,
       SUM (s4) s4,
       SUM (s5) s5,
       SUM (s6) s6,
       SUM (s7) s7,
       SUM (s8) s8,
       SUM (s9) s9,
       SUM (s10) s10,
       SUM (s12) s12,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s1) / SUM (akb)) * 100 d1,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s2) / SUM (akb)) * 100 d2,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s3) / SUM (akb)) * 100 d3,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s4) / SUM (akb)) * 100 d4,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s5) / SUM (akb)) * 100 d5,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s6) / SUM (akb)) * 100 d6,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s7) / SUM (akb)) * 100 d7,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s8) / SUM (akb)) * 100 d8,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s9) / SUM (akb)) * 100 d9,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s10) / SUM (akb)) * 100 d10,
       DECODE (NVL (SUM (akb), 0), 0, 0, SUM (s12) / SUM (akb)) * 100 d12,
       ROUND (AVG (b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8 + b9 + b10 + b12), 2) bt
  FROM (SELECT z.*,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d1 / 5 - 2), 1, d1 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d1 / 5 - 2), 1, d1 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d1 / 5 - 2), 1, d1 / 5 - 2, 0))))
                  b1,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d2 / 5 - 2), 1, d2 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d2 / 5 - 2), 1, d2 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d2 / 5 - 2), 1, d2 / 5 - 2, 0))))
                  b2,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d3 / 5 - 2), 1, d3 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d3 / 5 - 2), 1, d3 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d3 / 5 - 2), 1, d3 / 5 - 2, 0))))
                  b3,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d4 / 5 - 2), 1, d4 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d4 / 5 - 2), 1, d4 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d4 / 5 - 2), 1, d4 / 5 - 2, 0))))
                  b4,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d5 / 5 - 2), 1, d5 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d5 / 5 - 2), 1, d5 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d5 / 5 - 2), 1, d5 / 5 - 2, 0))))
                  b5,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d6 / 5 - 2), 1, d6 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d6 / 5 - 2), 1, d6 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d6 / 5 - 2), 1, d6 / 5 - 2, 0))))
                  b6,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d7 / 5 - 2), 1, d7 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d7 / 5 - 2), 1, d7 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d7 / 5 - 2), 1, d7 / 5 - 2, 0))))
                  b7,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d8 / 5 - 2), 1, d8 / 5 - 2, 0) - 3),
                          -1, 0,
                          DECODE (SIGN (10 - DECODE (SIGN (d8 / 5 - 2), 1, d8 / 5 - 2, 0)), -1, 10, DECODE (SIGN (d8 / 5 - 2), 1, d8 / 5 - 2, 0))))
                  b8,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d9 / 5 + 0), 1, d9 / 5 + 0, 0) - 5),
                          -1, 0,
                          DECODE (SIGN (12 - DECODE (SIGN (d9 / 5 + 0), 1, d9 / 5 + 0, 0)), -1, 12, DECODE (SIGN (d9 / 5 + 0), 1, d9 / 5 + 0, 0))))
                  b9,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d10 / 5 + 1), 1, d10 / 5 + 1, 0) - 6),
                          -1, 0,
                          DECODE (SIGN (13 - DECODE (SIGN (d10 / 5 + 1), 1, d10 / 5 + 1, 0)), -1, 13, DECODE (SIGN (d10 / 5 + 1), 1, d10 / 5 + 1, 0))))
                  b10,
               TRUNC (
                  DECODE (SIGN (DECODE (SIGN (d12 / 5 + 3), 1, d12 / 5 + 3, 0) - 8),
                          -1, 0,
                          DECODE (SIGN (15 - DECODE (SIGN (d12 / 5 + 3), 1, d12 / 5 + 3, 0)), -1, 15, DECODE (SIGN (d12 / 5 + 3), 1, d12 / 5 + 3, 0))))
                  b12
          FROM (SELECT u.fio,
                       t.*,
                       DECODE (NVL (akb, 0), 0, 0, s1 / akb) * 100 d1,
                       DECODE (NVL (akb, 0), 0, 0, s2 / akb) * 100 d2,
                       DECODE (NVL (akb, 0), 0, 0, s3 / akb) * 100 d3,
                       DECODE (NVL (akb, 0), 0, 0, s4 / akb) * 100 d4,
                       DECODE (NVL (akb, 0), 0, 0, s5 / akb) * 100 d5,
                       DECODE (NVL (akb, 0), 0, 0, s6 / akb) * 100 d6,
                       DECODE (NVL (akb, 0), 0, 0, s7 / akb) * 100 d7,
                       DECODE (NVL (akb, 0), 0, 0, s8 / akb) * 100 d8,
                       DECODE (NVL (akb, 0), 0, 0, s9 / akb) * 100 d9,
                       DECODE (NVL (akb, 0), 0, 0, s10 / akb) * 100 d10,
                       DECODE (NVL (akb, 0), 0, 0, s12 / akb) * 100 d12,
                       u.tn
                  FROM (  SELECT fio_eta,
                                 tab_num,
                                 SUM (akb) akb,
                                 SUM (s1) s1,
                                 SUM (s2) s2,
                                 SUM (s3) s3,
                                 SUM (s4) s4,
                                 SUM (s5) s5,
                                 SUM (s6) s6,
                                 SUM (s7) s7,
                                 SUM (s8) s8,
                                 SUM (s9) s9,
                                 SUM (s10) s10,
                                 SUM (s12) s12
                            FROM thing
                        GROUP BY fio_eta, tab_num) t,
                       user_list u
                 WHERE     u.tab_num = t.tab_num
                       AND u.dpt_id = :dpt_id
                       AND (u.tn IN (SELECT emp_tn
                                       FROM (    SELECT LPAD (z.emp, LENGTH (z.emp) + (LEVEL) * 3, '-'), LEVEL, z.*
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