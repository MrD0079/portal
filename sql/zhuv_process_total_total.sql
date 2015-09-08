/* Formatted on 11.01.2013 14:02:47 (QP5 v5.163.1008.3004) */
SELECT DECODE (SIGN (SUM (june) - SUM (may)), 1, SUM (june) - SUM (may), 0) d_jm,
       DECODE (SIGN (SUM (july) - SUM (may)), 1, SUM (july) - SUM (may), 0) d_jj,
       DECODE (SIGN (SUM (aug) - SUM (may)), 1, SUM (aug) - SUM (may), 0) d_aj,
       ROUND (SUM (b_june), 2) b_june,
       ROUND (SUM (b_july), 2) b_july,
       ROUND (SUM (b_aug), 2) b_aug,
       SUM (may) may,
       SUM (june) june,
       SUM (july) july,
       SUM (aug) aug
  FROM (SELECT z.*,
               DECODE (SIGN (3 - TRUNC (june / May)), 1, TRUNC (june / May), 3) * TRUNC (d_jm) * 5 b_june,
               DECODE (SIGN (3 - TRUNC (july / May)), 1, TRUNC (july / May), 3) * TRUNC (d_jj) * 5 b_july,
               DECODE (SIGN (3 - TRUNC (aug / May)), 1, TRUNC (aug / May), 3) * TRUNC (d_aj) * 5 b_aug
          FROM (SELECT u.fio,
                       t.*,
                       DECODE (SIGN (June - May), 1, June - May, 0) d_jm,
                       DECODE (SIGN (July - May), 1, July - May, 0) d_jj,
                       DECODE (SIGN (Aug - May), 1, Aug - May, 0) d_aj,
                       u.tn
                  FROM (  SELECT fio_eta,
                                 tab_num,
                                 SUM (Product_Qty_May) May,
                                 SUM (Product_Qty_June) June,
                                 SUM (Product_Qty_July) July,
                                 SUM (Product_Qty_Aug) Aug
                            FROM guviki
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
                                             START WITH exp_tn = DECODE (:zhuv_ts_list,
                                                                         0, DECODE (:zhuv_chief_list,
                                                                                    0, DECODE ( (SELECT NVL (is_super, 0) + NVL (is_traid, 0)
                                                                                                   FROM user_list
                                                                                                  WHERE tn = :tn),
                                                                                               0, :tn,
                                                                                               2923402273),
                                                                                    :zhuv_chief_list),
                                                                         0)
                                             CONNECT BY PRIOR emp_tn = exp_tn)
                                     UNION
                                     SELECT :tn FROM DUAL
                                     UNION
                                     SELECT DECODE (:zhuv_ts_list, 0, 0, :zhuv_ts_list) FROM DUAL))
                       AND u.tab_num <> 0) z) z1