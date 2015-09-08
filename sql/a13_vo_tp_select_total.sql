/* Formatted on 24.12.2013 12:29:09 (QP5 v5.227.12220.39724) */
SELECT SUM (selected) selected, SUM (prev) prev, SUM (summa) summa
  FROM (  SELECT v.tab_num,
                 st.fio fio_ts,
                 v.fio_eta,
                 v.tp_ur,
                 v.tp_addr,
                 v.tp_kod,
                 vtps.selected,
                 NVL (vtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = v.tp_kod AND ROWNUM = 1))
                    contact_lpr,
                 CASE
                    WHEN :month = 10 THEN NVL (v.s1_9, 0)
                    WHEN :month = 11 THEN NVL (s10f, 0)
                    WHEN :month = 12 THEN NVL (v.s11, 0)
                    WHEN :month = 13 THEN NVL (v.s1_9, 0)
                 END
                    prev,
                 CASE
                    WHEN :month = 10
                    THEN
                       NVL (v.s10, 0) - NVL (oh.summa, 0)
                    WHEN :month = 11
                    THEN
                       NVL (v.s11, 0) - NVL (nh.summa, 0) - NVL (yc.summa, 0)
                    WHEN :month = 12
                    THEN
                         NVL (v.s12, 0)
                       - NVL (hc.summa, 0)
                       - NVL (oy.summa, 0)
                       - NVL (sn.summa, 0)
                    WHEN :month = 13
                    THEN
                         NVL (v.s10, 0)
                       - NVL (oh.summa, 0)
                       + NVL (v.s11, 0)
                       - NVL (nh.summa, 0)
                       - NVL (yc.summa, 0)
                       + NVL (v.s12, 0)
                       - NVL (hc.summa, 0)
                       - NVL (oy.summa, 0)
                       - NVL (sn.summa, 0)
                 END
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
                           AND oh.H_TP_KOD_DATA_NAKL = OH_AN.H_TP_KOD_DATA_NAKL
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
                           AND nh.H_TP_KOD_DATA_NAKL = nh_AN.H_TP_KOD_DATA_NAKL
                           AND nh_an.if1 = 1
                  GROUP BY nh.tp_kod) nh,
                 (  SELECT nh.tp_kod, SUM (summa) summa
                      FROM a13_yc nh,
                           a13_yc_tp_select nh_tp,
                           a13_yc_action_nakl nh_an
                     WHERE     nh.tp_kod = nh_tp.tp_kod
                           AND nh_tp.selected = 1
                           AND nh.H_TP_KOD_DATA_NAKL = nh_AN.H_TP_KOD_DATA_NAKL
                           AND nh_an.if1 = 1
                  GROUP BY nh.tp_kod) yc,
                 (  SELECT d.tp_kod, SUM (d.summa) summa
                      FROM a13_hc d, a13_hc_action_nakl an, a13_hc_tp_select tp
                     WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                           AND d.tp_kod = tp.tp_kod
                           AND an.if1 = 1
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod) hc,
                 (  SELECT d.tp_kod, SUM (d.summa) summa
                      FROM a13_oy d, a13_oy_action_nakl an, a13_oy_tp_select tp
                     WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                           AND d.tp_kod = tp.tp_kod
                           AND an.if1 = 1
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod) oy,
                 (  SELECT d.tp_kod, SUM (d.summa) summa
                      FROM a13_sn d, a13_sn_action_nakl an, a13_sn_tp_select tp
                     WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                           AND d.tp_kod = tp.tp_kod
                           AND an.if1 = 1
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod) sn
           WHERE     v.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND v.tp_kod = vtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
                 AND vtps.m(+) = :month
                 AND CASE
                        WHEN :month = 10 THEN NVL (v.s1_9, 0)
                        WHEN :month = 11 THEN NVL (v.s1_9, 0)
                        WHEN :month = 12 THEN NVL (v.s1_9, 0)
                        WHEN :month = 13 THEN -NVL (v.s1_9, 0)
                     END >=
                        CASE
                           WHEN :month = 10 THEN 3500
                           WHEN :month = 11 THEN 3500
                           WHEN :month = 12 THEN 3500
                           WHEN :month = 13 THEN -10000
                        END
                 AND v.tp_kod = oh.tp_kod(+)
                 AND v.tp_kod = nh.tp_kod(+)
                 AND v.tp_kod = yc.tp_kod(+)
                 AND v.tp_kod = hc.tp_kod(+)
                 AND v.tp_kod = oy.tp_kod(+)
                 AND v.tp_kod = sn.tp_kod(+)
        ORDER BY fio_ts, fio_eta, tp_ur)