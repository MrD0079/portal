/* Formatted on 11.01.2013 12:59:55 (QP5 v5.163.1008.3004) */
  SELECT fn_apvd_ball_eta (fio_eta) ball,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = z1.tn))
            fio_parent,
         fio_ts,
         tab_num,
         fio_eta,
         a10akb,
         a10s1,
         a10s2,
         a10s3,
         a10s4,
         a10s5,
         a10s6,
         a10s7,
         a10s8,
         a10s9,
         a10s10,
         a10s11,
         a10s12,
         a10s13,
         a10s14,
         a10s15,
         a10s16,
         a10s17,
         a10s18,
         a11akb,
         a11s1,
         a11s2,
         a11s3,
         a11s4,
         a11s5,
         a11s6,
         a11s7,
         a11s8,
         a11s9,
         a11s10,
         a11s11,
         a11s12,
         a11s13,
         a11s14,
         a11s15,
         a11s16,
         a11s17,
         a11s18,
         d10s1,
         d10s2,
         d10s3,
         d10s4,
         d10s5,
         d10s6,
         d10s7,
         d10s8,
         d10s9,
         d10s10,
         d10s11,
         d10s12,
         d10s13,
         d10s14,
         d10s15,
         d10s16,
         d10s17,
         d10s18,
         d11s1,
         d11s2,
         d11s3,
         d11s4,
         d11s5,
         d11s6,
         d11s7,
         d11s8,
         d11s9,
         d11s10,
         d11s11,
         d11s12,
         d11s13,
         d11s14,
         d11s15,
         d11s16,
         d11s17,
         d11s18,
         TRUNC (DECODE (SIGN (b1), -1, 0, b1)) b1,
         TRUNC (DECODE (SIGN (b2), -1, 0, b2)) b2,
         TRUNC (DECODE (SIGN (b3), -1, 0, b3)) b3,
         TRUNC (DECODE (SIGN (b4), -1, 0, b4)) b4,
         TRUNC (DECODE (SIGN (b5), -1, 0, b5)) b5,
         TRUNC (DECODE (SIGN (b6), -1, 0, b6)) b6,
         TRUNC (DECODE (SIGN (b7), -1, 0, b7)) b7,
         TRUNC (DECODE (SIGN (b8), -1, 0, b8)) b8,
         TRUNC (DECODE (SIGN (b9), -1, 0, b9)) b9,
         TRUNC (DECODE (SIGN (b10), -1, 0, b10)) b10,
         TRUNC (DECODE (SIGN (b11), -1, 0, b11)) b11,
         TRUNC (DECODE (SIGN (b12), -1, 0, b12)) b12,
         TRUNC (DECODE (SIGN (b13), -1, 0, b13)) b13,
         TRUNC (DECODE (SIGN (b14), -1, 0, b14)) b14,
         TRUNC (DECODE (SIGN (b15), -1, 0, b15)) b15,
         TRUNC (DECODE (SIGN (b16), -1, 0, b16)) b16,
         TRUNC (DECODE (SIGN (b17), -1, 0, b17)) b17,
         TRUNC (DECODE (SIGN (b18), -1, 0, b18)) b18,
         --       z1.*,

         /*b1+b2+b3+b4+b5+b6+b7+b8+b9+b10+b11+b12+b13+b14+b15+b16+b17*/
         TRUNC (
              TRUNC (DECODE (SIGN (b1), -1, 0, b1))
            + TRUNC (DECODE (SIGN (b2), -1, 0, b2))
            + TRUNC (DECODE (SIGN (b3), -1, 0, b3))
            + TRUNC (DECODE (SIGN (b4), -1, 0, b4))
            + TRUNC (DECODE (SIGN (b5), -1, 0, b5))
            + TRUNC (DECODE (SIGN (b6), -1, 0, b6))
            + TRUNC (DECODE (SIGN (b7), -1, 0, b7))
            + TRUNC (DECODE (SIGN (b8), -1, 0, b8))
            + TRUNC (DECODE (SIGN (b9), -1, 0, b9))
            + TRUNC (DECODE (SIGN (b10), -1, 0, b10))
            + TRUNC (DECODE (SIGN (b11), -1, 0, b11))
            + TRUNC (DECODE (SIGN (b12), -1, 0, b12))
            + TRUNC (DECODE (SIGN (b13), -1, 0, b13))
            + TRUNC (DECODE (SIGN (b14), -1, 0, b14))
            + TRUNC (DECODE (SIGN (b15), -1, 0, b15))
            + TRUNC (DECODE (SIGN (b16), -1, 0, b16))
            + TRUNC (DECODE (SIGN (b17), -1, 0, b17)))
            ob,
         /*b1+b2+b3+b4+b5+b6+b7+b8+b9+b10+b11+b12+b13+b14+b15+b16+b17+b18*/
         TRUNC (
              TRUNC (DECODE (SIGN (b1), -1, 0, b1))
            + TRUNC (DECODE (SIGN (b2), -1, 0, b2))
            + TRUNC (DECODE (SIGN (b3), -1, 0, b3))
            + TRUNC (DECODE (SIGN (b4), -1, 0, b4))
            + TRUNC (DECODE (SIGN (b5), -1, 0, b5))
            + TRUNC (DECODE (SIGN (b6), -1, 0, b6))
            + TRUNC (DECODE (SIGN (b7), -1, 0, b7))
            + TRUNC (DECODE (SIGN (b8), -1, 0, b8))
            + TRUNC (DECODE (SIGN (b9), -1, 0, b9))
            + TRUNC (DECODE (SIGN (b10), -1, 0, b10))
            + TRUNC (DECODE (SIGN (b11), -1, 0, b11))
            + TRUNC (DECODE (SIGN (b12), -1, 0, b12))
            + TRUNC (DECODE (SIGN (b13), -1, 0, b13))
            + TRUNC (DECODE (SIGN (b14), -1, 0, b14))
            + TRUNC (DECODE (SIGN (b15), -1, 0, b15))
            + TRUNC (DECODE (SIGN (b16), -1, 0, b16))
            + TRUNC (DECODE (SIGN (b17), -1, 0, b17))
            + TRUNC (DECODE (SIGN (b18), -1, 0, b18)))
            obsv
    FROM (SELECT u.fio fio_ts,
                 t.*,
                 NVL (DECODE (a10akb, 0, 0, a10s1 / a10akb) * 100 + 10, 0) d10s1,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s2 / a10akb) * 100 + 10, 0) d10s2,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s3 / a10akb) * 100 + 10, 0) d10s3,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s4 / a10akb) * 100 + 10, 0) d10s4,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s5 / a10akb) * 100 + 10, 0) d10s5,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s6 / a10akb) * 100 + 10, 0) d10s6,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s7 / a10akb) * 100 + 10, 0) d10s7,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s8 / a10akb) * 100 + 10, 0) d10s8,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s9 / a10akb) * 100 + 10, 0) d10s9,                                                                                                    /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s10 / a10akb) * 100 + 10, 0) d10s10,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s11 / a10akb) * 100 + 10, 0) d10s11,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s12 / a10akb) * 100 + 10, 0) d10s12,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s13 / a10akb) * 100 + 10, 0) d10s13,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s14 / a10akb) * 100 + 10, 0) d10s14,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s15 / a10akb) * 100 + 10, 0) d10s15,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s16 / a10akb) * 100 + 10, 0) d10s16,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s17 / a10akb) * 100 + 10, 0) d10s17,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a10akb, 0, 0, a10s18 / a10akb) * 100 + 10, 0) d10s18,                                                                                                  /* дистр окт +5% */
                 NVL (DECODE (a11akb, 0, 0, a11s1 / a11akb) * 100, 0) d11s1,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s2 / a11akb) * 100, 0) d11s2,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s3 / a11akb) * 100, 0) d11s3,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s4 / a11akb) * 100, 0) d11s4,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s5 / a11akb) * 100, 0) d11s5,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s6 / a11akb) * 100, 0) d11s6,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s7 / a11akb) * 100, 0) d11s7,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s8 / a11akb) * 100, 0) d11s8,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s9 / a11akb) * 100, 0) d11s9,                                                                                                             /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s10 / a11akb) * 100, 0) d11s10,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s11 / a11akb) * 100, 0) d11s11,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s12 / a11akb) * 100, 0) d11s12,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s13 / a11akb) * 100, 0) d11s13,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s14 / a11akb) * 100, 0) d11s14,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s15 / a11akb) * 100, 0) d11s15,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s16 / a11akb) * 100, 0) d11s16,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s17 / a11akb) * 100, 0) d11s17,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s18 / a11akb) * 100, 0) d11s18,                                                                                                           /* дистр ноя */
                 NVL (DECODE (a11akb, 0, 0, a11s1 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s1 / a10akb) * 100 + 10), 0) b1,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s2 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s2 / a10akb) * 100 + 10), 0) b2,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s3 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s3 / a10akb) * 100 + 10), 0) b3,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s4 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s4 / a10akb) * 100 + 10), 0) b4,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s5 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s5 / a10akb) * 100 + 10), 0) b5,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s6 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s6 / a10akb) * 100 + 10), 0) b6,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s7 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s7 / a10akb) * 100 + 10), 0) b7,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s8 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s8 / a10akb) * 100 + 10), 0) b8,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s9 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s9 / a10akb) * 100 + 10), 0) b9,                                                                /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s10 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s10 / a10akb) * 100 + 10), 0) b10,                                                             /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s11 / a11akb) * 100 - 40, 0) b11,                                                                                                              /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s12 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s12 / a10akb) * 100 + 10), 0) b12,                                                             /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s13 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s13 / a10akb) * 100 + 10), 0) b13,                                                             /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s14 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s14 / a10akb) * 100 + 10), 0) b14,                                                             /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s15 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s15 / a10akb) * 100 + 10), 0) b15,                                                             /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s16 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s16 / a10akb) * 100 + 10), 0) b16,                                                             /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s17 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s17 / a10akb) * 100 + 10), 0) b17,                                                             /* балл */
                 NVL (DECODE (a11akb, 0, 0, a11s18 / a11akb) * 100 - (DECODE (a10akb, 0, 0, a10s18 / a10akb) * 100 + 10), 0) b18,                                                             /* балл */
                 u.tn
            FROM (SELECT a10.fio_eta,
                         a10.tab_num,
                         NVL (a10.akb, 0) a10akb,
                         a10.s1 a10s1,
                         a10.s2 a10s2,
                         a10.s3 a10s3,
                         a10.s4 a10s4,
                         a10.s5 a10s5,
                         a10.s6 a10s6,
                         a10.s7 a10s7,
                         a10.s8 a10s8,
                         a10.s9 a10s9,
                         a10.s10 a10s10,
                         a10.s11 a10s11,
                         a10.s12 a10s12,
                         a10.s13 a10s13,
                         a10.s14 a10s14,
                         a10.s15 a10s15,
                         a10.s16 a10s16,
                         a10.s17 a10s17,
                         a10.s18 a10s18,
                         NVL (a11.akb, 0) a11akb,
                         a11.s1 a11s1,
                         a11.s2 a11s2,
                         a11.s3 a11s3,
                         a11.s4 a11s4,
                         a11.s5 a11s5,
                         a11.s6 a11s6,
                         a11.s7 a11s7,
                         a11.s8 a11s8,
                         a11.s9 a11s9,
                         a11.s10 a11s10,
                         a11.s11 a11s11,
                         a11.s12 a11s12,
                         a11.s13 a11s13,
                         a11.s14 a11s14,
                         a11.s15 a11s15,
                         a11.s16 a11s16,
                         a11.s17 a11s17,
                         a11.s18 a11s18
                    FROM (  SELECT fio_eta,
                                   tab_num,
                                   parent_tn,
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
                                   SUM (s11) s11,
                                   SUM (s12) s12,
                                   SUM (s13) s13,
                                   SUM (s14) s14,
                                   SUM (s15) s15,
                                   SUM (s16) s16,
                                   SUM (s17) s17,
                                   SUM (s18) s18
                              FROM apvd12_eta
                             WHERE is_show = 1
                          GROUP BY fio_eta, tab_num, parent_tn) a10,
                         (  SELECT fio_eta,
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
                                   SUM (s11) s11,
                                   SUM (s12) s12,
                                   SUM (s13) s13,
                                   SUM (s14) s14,
                                   SUM (s15) s15,
                                   SUM (s16) s16,
                                   SUM (s17) s17,
                                   SUM (s18) s18
                              FROM apvd12
                             WHERE m = 12
                          GROUP BY fio_eta, tab_num) a11
                   WHERE a10.parent_tn = a11.tab_num(+) AND a10.fio_eta = a11.fio_eta(+)) t,
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
                                       START WITH exp_tn = DECODE (:apvd12_ts_list,
                                                                   0, DECODE (:apvd12_chief_list,
                                                                              0, DECODE ( (SELECT NVL (is_super, 0) + NVL (is_traid, 0)
                                                                                             FROM user_list
                                                                                            WHERE tn = :tn),
                                                                                         0, :tn,
                                                                                         2923402273),
                                                                              :apvd12_chief_list),
                                                                   0)
                                       CONNECT BY PRIOR emp_tn = exp_tn)
                               UNION
                               SELECT :tn FROM DUAL
                               UNION
                               SELECT DECODE (:apvd12_ts_list, 0, 0, :apvd12_ts_list) FROM DUAL))
                 AND u.tab_num <> 0) z1
ORDER BY fio_parent, fio_ts, fio_eta