/* Formatted on 21.11.2012 15:15:32 (QP5 v5.163.1008.3004) */
SELECT *
  FROM (  SELECT DISTINCT a.fio_eta,
                          a.tab_num,
                          u.fio fio_ts,
                          NVL (ae.parent_tn, a.tab_num) parent_tn,
                          NVL (ae.akb, NVL (a10.akb, 0)) akb,
                          NVL (ae.s1, NVL (a10.s1, 0)) s1,
                          NVL (ae.s2, NVL (a10.s2, 0)) s2,
                          NVL (ae.s3, NVL (a10.s3, 0)) s3,
                          NVL (ae.s4, NVL (a10.s4, 0)) s4,
                          NVL (ae.s5, NVL (a10.s5, 0)) s5,
                          NVL (ae.s6, NVL (a10.s6, 0)) s6,
                          NVL (ae.s7, NVL (a10.s7, 0)) s7,
                          NVL (ae.s8, NVL (a10.s8, 0)) s8,
                          NVL (ae.s9, NVL (a10.s9, 0)) s9,
                          NVL (ae.s10, NVL (a10.s10, 0)) s10,
                          NVL (ae.s11, NVL (a10.s11, 0)) s11,
                          NVL (ae.s12, NVL (a10.s12, 0)) s12,
                          NVL (ae.s13, NVL (a10.s13, 0)) s13,
                          NVL (ae.s14, NVL (a10.s14, 0)) s14,
                          NVL (ae.s15, NVL (a10.s15, 0)) s15,
                          NVL (ae.s16, NVL (a10.s16, 0)) s16,
                          NVL (ae.s17, NVL (a10.s17, 0)) s17,
                          NVL (ae.s18, NVL (a10.s18, 0)) s18,
                          NVL (ae.is_show, 1) is_show
            FROM (SELECT DISTINCT fio_eta, tab_num FROM apvd
                  UNION
                  SELECT fio_eta, tab_num FROM apvd_eta) a,
                 user_list u,
                 apvd_eta ae,
                 (SELECT *
                    FROM apvd
                   WHERE m = 10) a10
           WHERE     u.tab_num = a.tab_num
                 AND u.tab_num <> 0
                 AND u.dpt_id = :dpt_id
                 AND a.fio_eta = ae.fio_eta(+)
                 AND a.tab_num = ae.tab_num(+)
                 AND a.fio_eta = a10.fio_eta(+)
                 AND a.tab_num = a10.tab_num(+)
        ORDER BY a.fio_eta, u.fio)
-- WHERE ROWNUM <= 10