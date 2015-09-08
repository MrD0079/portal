/* Formatted on 11.01.2014 15:35:31 (QP5 v5.227.12220.39724) */
  SELECT x.parent_tn db_tn,
         u.fio db_fio,
         v.ok_traid,
         TO_CHAR (v.ok_traid_lu, 'dd.mm.yyyy hh24:mi:ss') ok_traid_lu,
         v.ok_traid_fio,
         DECODE (v.ok_traid, NULL, COUNT (DISTINCT x.tp_kod), v.rec_count)
            rec_count,
         DECODE (v.ok_traid,
                 NULL, SUM (DECODE (x.bonus_dt1, NULL, NULL, x.bonus_sum1)),
                 v.sum_bonus)
            sum_bonus,
         DECODE (v.ok_traid,
                 NULL, DECODE (f.sum_files, NULL, NULL, f.sum_files),
                 v.sum_files)
            sum_files
    FROM ACT_OK v,
                                    (  SELECT p1.parent parent_tn, SUM (bonus) sum_files
                            FROM ACT_FILES x1, parents p1
             WHERE x1.tn = p1.tn and act=:act and x1.m=:month

          GROUP BY p1.parent) f,


         user_list u,
         (  SELECT tp.*,
                   vo.tp_kod vo1,
                   vo.prev,
                   vo.summa,
                   nv.tp_kod nv1,
                   nv.salesnov,
                   nv.salesdec,
                   st.fio ts_fio,
                   (SELECT DECODE (lu, NULL, 0, 1)
                      FROM ACT_OK
                     WHERE tn = (SELECT parent
                                   FROM parents
                                  WHERE tn = st.tn) and m=:month and act=:act)
                      ok_chief,
                   TO_CHAR (tps.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
                   tps.bonus_sum1,
                   fn_getname (
                                (SELECT parent
                                   FROM parents
                                  WHERE tn = st.tn))
                      parent_fio,
                   (SELECT parent
                      FROM parents
                     WHERE tn = st.tn)
                      parent_tn,
                   (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
                      FROM ACT_OK
                     WHERE tn = (SELECT parent
                                   FROM parents
                                  WHERE tn = st.tn) and m=:month and act=:act)
                      ok_chief_date
              FROM A14_01_LPR_v tp,
                   A14_01_LPR_tp_select tps,
                   (SELECT v.tab_num,
                           v.tp_kod,
                           NVL (v.s1_9, 0) prev,
                             NVL (v.s10, 0)
                           - NVL (oh.summa, 0)
                           + NVL (v.s11, 0)
                           - NVL (nh.summa, 0)
                           - NVL (yc.summa, 0)
                           + NVL (v.s12, 0)
                           - NVL (hc.summa, 0)
                           - NVL (oy.summa, 0)
                           - NVL (sn.summa, 0)
                              summa
                      FROM a13_vo_tp_select vtps,
                           a13_vo v,
                           user_list st,
                           (  SELECT oh.tp_kod, SUM (summa) summa
                                FROM a13_oh10 oh,
                                     a13_oh10_tp_select oh_tp,
                                     a13_oh10_action_nakl oh_an
                               WHERE     oh.tp_kod = oh_tp.tp_kod
                                     AND oh_tp.selected = 1
                                     AND oh.H_TP_KOD_DATA_NAKL =
                                            OH_AN.H_TP_KOD_DATA_NAKL
                                     AND oh_an.if1 = 1
                                     AND OH.DATA BETWEEN TO_DATE ('14.10.2013',
                                                                  'dd.mm.yyyy')
                                                     AND TO_DATE ('31.10.2013',
                                                                  'dd.mm.yyyy')
                            GROUP BY oh.tp_kod) oh,
                           (  SELECT nh.tp_kod, SUM (summa) summa
                                FROM a13_nh nh,
                                     a13_nh_tp_select nh_tp,
                                     a13_nh_action_nakl nh_an
                               WHERE     nh.tp_kod = nh_tp.tp_kod
                                     AND nh_tp.selected = 1
                                     AND nh.H_TP_KOD_DATA_NAKL =
                                            nh_AN.H_TP_KOD_DATA_NAKL
                                     AND nh_an.if1 = 1
                            GROUP BY nh.tp_kod) nh,
                           (  SELECT nh.tp_kod, SUM (summa) summa
                                FROM a13_yc nh,
                                     a13_yc_tp_select nh_tp,
                                     a13_yc_action_nakl nh_an
                               WHERE     nh.tp_kod = nh_tp.tp_kod
                                     AND nh_tp.selected = 1
                                     AND nh.H_TP_KOD_DATA_NAKL =
                                            nh_AN.H_TP_KOD_DATA_NAKL
                                     AND nh_an.if1 = 1
                            GROUP BY nh.tp_kod) yc,
                           (  SELECT d.tp_kod, SUM (d.summa) summa
                                FROM a13_hc d,
                                     a13_hc_action_nakl an,
                                     a13_hc_tp_select tp
                               WHERE     d.H_TP_KOD_DATA_NAKL =
                                            an.H_TP_KOD_DATA_NAKL
                                     AND d.tp_kod = tp.tp_kod
                                     AND an.if1 = 1
                                     AND TRUNC (d.data, 'mm') =
                                            TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                            GROUP BY d.tp_kod) hc,
                           (  SELECT d.tp_kod, SUM (d.summa) summa
                                FROM a13_oy d,
                                     a13_oy_action_nakl an,
                                     a13_oy_tp_select tp
                               WHERE     d.H_TP_KOD_DATA_NAKL =
                                            an.H_TP_KOD_DATA_NAKL
                                     AND d.tp_kod = tp.tp_kod
                                     AND an.if1 = 1
                                     AND TRUNC (d.data, 'mm') =
                                            TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                            GROUP BY d.tp_kod) oy,
                           (  SELECT d.tp_kod, SUM (d.summa) summa
                                FROM a13_sn d,
                                     a13_sn_action_nakl an,
                                     a13_sn_tp_select tp
                               WHERE     d.H_TP_KOD_DATA_NAKL =
                                            an.H_TP_KOD_DATA_NAKL
                                     AND d.tp_kod = tp.tp_kod
                                     AND an.if1 = 1
                                     AND TRUNC (d.data, 'mm') =
                                            TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                            GROUP BY d.tp_kod) sn
                     WHERE     v.tab_num = st.tab_num
                           AND v.tp_kod = vtps.tp_kod
                           AND st.dpt_id = :dpt_id
                           AND vtps.selected = 1
                           AND vtps.m = 13
                           AND v.tp_kod = oh.tp_kod(+)
                           AND v.tp_kod = nh.tp_kod(+)
                           AND v.tp_kod = yc.tp_kod(+)
                           AND v.tp_kod = hc.tp_kod(+)
                           AND v.tp_kod = oy.tp_kod(+)
                           AND v.tp_kod = sn.tp_kod(+)
                           AND   NVL (v.s10, 0)
                               - NVL (oh.summa, 0)
                               + NVL (v.s11, 0)
                               - NVL (nh.summa, 0)
                               - NVL (yc.summa, 0)
                               + NVL (v.s12, 0)
                               - NVL (hc.summa, 0)
                               - NVL (oy.summa, 0)
                               - NVL (sn.summa, 0) >= 50000) vo,
                   (SELECT d.tab_num,
                           d.tp_kod,
                           d.salesnov,
                             d.salesdec
                           - NVL (hc.summa, 0)
                           - NVL (oy.summa, 0)
                           - NVL (sn.summa, 0)
                              salesdec
                      FROM a13_nv d,
                           user_list st,
                           a13_nv_tp_select tp,
                           (  SELECT d.tp_kod, SUM (d.summa) summa
                                FROM a13_hc d,
                                     a13_hc_action_nakl an,
                                     a13_hc_tp_select tp
                               WHERE     d.H_TP_KOD_DATA_NAKL =
                                            an.H_TP_KOD_DATA_NAKL
                                     AND d.tp_kod = tp.tp_kod
                                     AND an.if1 = 1
                                     AND TRUNC (d.data, 'mm') =
                                            TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                            GROUP BY d.tp_kod) hc,
                           (  SELECT d.tp_kod, SUM (d.summa) summa
                                FROM a13_oy d,
                                     a13_oy_action_nakl an,
                                     a13_oy_tp_select tp
                               WHERE     d.H_TP_KOD_DATA_NAKL =
                                            an.H_TP_KOD_DATA_NAKL
                                     AND d.tp_kod = tp.tp_kod
                                     AND an.if1 = 1
                                     AND TRUNC (d.data, 'mm') =
                                            TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                            GROUP BY d.tp_kod) oy,
                           (  SELECT d.tp_kod, SUM (d.summa) summa
                                FROM a13_sn d,
                                     a13_sn_action_nakl an,
                                     a13_sn_tp_select tp
                               WHERE     d.H_TP_KOD_DATA_NAKL =
                                            an.H_TP_KOD_DATA_NAKL
                                     AND d.tp_kod = tp.tp_kod
                                     AND an.if1 = 1
                                     AND TRUNC (d.data, 'mm') =
                                            TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                            GROUP BY d.tp_kod) sn
                     WHERE     d.tab_num = st.tab_num
                           AND st.dpt_id = :dpt_id
                           AND d.tp_kod = tp.tp_kod
                           AND tp.selected = 1
                           AND d.tp_kod = hc.tp_kod(+)
                           AND d.tp_kod = oy.tp_kod(+)
                           AND d.tp_kod = sn.tp_kod(+)
                           AND DECODE (
                                  CASE
                                     WHEN       d.salesdec
                                              - NVL (hc.summa, 0)
                                              - NVL (oy.summa, 0)
                                              - NVL (sn.summa, 0)
                                              - d.salesnov > 0
                                          AND d.salesnov > 0
                                     THEN
                                        TRUNC (
                                             (    (  d.salesdec
                                                   - NVL (hc.summa, 0)
                                                   - NVL (oy.summa, 0)
                                                   - NVL (sn.summa, 0))
                                                / d.salesnov
                                              - 1)
                                           * 100)
                                     ELSE
                                        0
                                  END,
                                  0, 0,
                                  1) = 1) nv,
                   user_list st
             WHERE     tp.tab_num = st.tab_num
                   AND st.dpt_id = :dpt_id
                   AND tp.tp_kod = vo.tp_kod(+)
                   AND tp.tp_kod = nv.tp_kod(+)
                   AND tp.tp_kod = tps.tp_kod(+)
          ORDER BY parent_fio, ts_fio, tp.fio_eta) x
      WHERE     x.parent_tn = v.tn
         AND u.tn = x.parent_tn
         AND x.parent_tn = f.parent_tn(+)
         AND v.m = :month
         and v.act=:act
GROUP BY x.parent_tn,
         u.fio,
         v.ok_traid,
         v.ok_traid_lu,
         v.ok_traid_fio,
         v.rec_count,
         v.sum_bonus,
         v.sum_files,
         f.sum_files
ORDER BY db_fio