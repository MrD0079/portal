/* Formatted on 24.09.2013 15:12:08 (QP5 v5.227.12220.39724) */
SELECT SUM (selected) selected, SUM (sum08) sum08, SUM (sum09) sum09
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
                 NVL (sum08, 0) sum08,
                   NVL (sum09, 0)
                 - NVL (sv9.summa, 0)
                 - NVL (nd9.summa, 0)
                 - NVL (sm8.summa, 0)
                 - NVL (ss8.summa, 0)
                 - NVL (sp8.summa, 0)
                    sum09
            FROM a13_va9_tp_select vtps,
                 a13_va9 v,
                 user_list st,
                 (  SELECT a.tp_kod, SUM (a.summa) summa
                      FROM a13_sv9 a, a13_sv9_tp_select t, a13_sv9_action_nakl n
                     WHERE     TRUNC (a.data, 'mm') =
                                  TO_DATE ('01.09.2013', 'dd.mm.yyyy')
                           AND A.TP_KOD = T.TP_KOD
                           AND T.SELECTED = 1
                           AND A.H_TP_KOD_DATA_NAKL = N.H_TP_KOD_DATA_NAKL
                           AND NVL (n.if1, 0) > 0
                  GROUP BY a.tp_kod) sv9,
                 (  SELECT a.tp_kod, SUM (a.summa) summa
                      FROM a13_nd9 a, a13_nd9_tp_select t, a13_nd9_action_nakl n
                     WHERE     TRUNC (a.data, 'mm') =
                                  TO_DATE ('01.09.2013', 'dd.mm.yyyy')
                           AND A.TP_KOD = T.TP_KOD
                           AND T.SELECTED = 1
                           AND A.H_TP_KOD_DATA_NAKL = N.H_TP_KOD_DATA_NAKL
                           AND NVL (n.if1, 0) > 0
                  GROUP BY a.tp_kod) nd9,
                 (  SELECT a.tp_kod, SUM (a.summa) summa
                      FROM a13_sm8 a, a13_sm8_tp_select t, a13_sm8_action_nakl n
                     WHERE     TRUNC (a.data, 'mm') =
                                  TO_DATE ('01.09.2013', 'dd.mm.yyyy')
                           AND A.TP_KOD = T.TP_KOD
                           AND T.SELECTED = 1
                           AND A.H_TP_KOD_DATA_NAKL = N.H_TP_KOD_DATA_NAKL
                           AND NVL (n.if1, 0) + NVL (n.if2, 0) > 0
                  GROUP BY a.tp_kod) sm8,
                 (  SELECT a.tp_kod, SUM (a.summa) summa
                      FROM a13_ss8 a, a13_ss8_tp_select t, a13_ss8_action_nakl n
                     WHERE     TRUNC (a.data, 'mm') =
                                  TO_DATE ('01.09.2013', 'dd.mm.yyyy')
                           AND A.TP_KOD = T.TP_KOD
                           AND T.SELECTED = 1
                           AND A.H_TP_KOD_DATA_NAKL = N.H_TP_KOD_DATA_NAKL
                           AND NVL (n.if1, 0) + NVL (n.if2, 0) > 0
                  GROUP BY a.tp_kod) ss8,
                 (  SELECT a.tp_kod, SUM (a.summa) summa
                      FROM a13_sp8 a, a13_sp8_tp_select t, a13_sp8_action_nakl n
                     WHERE     TRUNC (a.data, 'mm') =
                                  TO_DATE ('01.09.2013', 'dd.mm.yyyy')
                           AND A.TP_KOD = T.TP_KOD
                           AND T.SELECTED = 1
                           AND A.H_TP_KOD_DATA_NAKL = N.H_TP_KOD_DATA_NAKL
                           AND NVL (n.if1, 0) + NVL (n.if2, 0) > 0
                  GROUP BY a.tp_kod) sp8
           WHERE     v.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND v.tp_kod = vtps.tp_kod(+)
                 AND v.tp_kod = sv9.tp_kod(+)
                 AND v.tp_kod = nd9.tp_kod(+)
                 AND v.tp_kod = sm8.tp_kod(+)
                 AND v.tp_kod = ss8.tp_kod(+)
                 AND v.tp_kod = sp8.tp_kod(+)
                 AND st.dpt_id = :dpt_id
                 AND NVL (sum08, 0) > 0
        ORDER BY fio_ts, fio_eta, tp_ur)