/* Formatted on 10.12.2012 14:18:53 (QP5 v5.163.1008.3004) */
SELECT *
  FROM (  SELECT a.fio_eta,
                 'Ёксклюзивный торговый агент' pos_name,
                 fn_apvd_ball_eta (a.fio_eta) ball,
                 a.akb,
                 a.a11_akb
            FROM (SELECT NVL (a11.akb, 0) a11_akb, a10.*
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
                              FROM apvd_eta
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
                              FROM apvd
                             WHERE m = 11
                          GROUP BY fio_eta, tab_num) a11
                   WHERE a10.parent_tn = a11.tab_num(+) AND a10.fio_eta = a11.fio_eta(+)) a,
                 user_list u
           WHERE     a.tab_num = u.tab_num
                 AND u.dpt_id = :dpt_id
                 AND fn_apvd_ball_eta (a.fio_eta) <> 0
                 AND u.tn IN (SELECT slave
                                FROM full
                               WHERE master = :tn)
        ORDER BY ball DESC)
 WHERE ROWNUM <= 20