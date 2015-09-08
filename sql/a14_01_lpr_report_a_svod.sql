/* Formatted on 21.01.2015 21:46:27 (QP5 v5.227.12220.39724) */
INSERT INTO act_svod (act,
                      m,
                      sales,
                      bonus,
                      tp,
                      fio_db,
                      fio_ts,
                      ts_tab_num,
                      fio_eta,
                      h_fio_eta,
                      db_tn,
                      dpt_id)
     SELECT act,
            m,
            SUM (sales) sales,
            SUM (bonus) bonus,
            COUNT (*) tp,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn,
            :dpt_id

       FROM (SELECT :act act,
                    :month m,
                    vo.summa sales,
                    tps.bonus_sum1 bonus,
                    tp.tp_kod,
                    fn_getname (
                                 (SELECT parent
                                    FROM parents
                                   WHERE tn = st.tn))
                       fio_db,
                    st.fio fio_ts,
                    st.tab_num ts_tab_num,
                    tp.fio_eta,
                    tp.h_fio_eta,
                    (SELECT parent
                       FROM parents
                      WHERE tn = st.tn)
                       db_tn
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
                            AND st.tn IN
                                   (SELECT slave
                                      FROM full
                                     WHERE master =
                                              DECODE (:exp_list_without_ts,
                                                      0, master,
                                                      :exp_list_without_ts))
                            AND st.tn IN
                                   (SELECT slave
                                      FROM full
                                     WHERE master =
                                              DECODE (:exp_list_only_ts,
                                                      0, master,
                                                      :exp_list_only_ts))
                            AND (   st.tn IN
                                       (SELECT slave
                                          FROM full
                                         WHERE master =
                                                  DECODE (:tn, -1, master, :tn))
                                 OR (SELECT NVL (is_traid, 0)
                                       FROM user_list
                                      WHERE tn = :tn) = 1)
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
                            AND st.tn IN
                                   (SELECT slave
                                      FROM full
                                     WHERE master =
                                              DECODE (
                                                 :exp_list_without_ts,
                                                 0, DECODE (
                                                       :tn,
                                                       -1, (SELECT MAX (tn)
                                                              FROM user_list
                                                             WHERE is_admin = 1),
                                                       :tn),
                                                 :exp_list_without_ts))
                            AND st.tn IN
                                   (SELECT slave
                                      FROM full
                                     WHERE master =
                                              DECODE (
                                                 :exp_list_only_ts,
                                                 0, DECODE (
                                                       :tn,
                                                       -1, (SELECT MAX (tn)
                                                              FROM user_list
                                                             WHERE is_admin = 1),
                                                       :tn),
                                                 :exp_list_only_ts))
                            AND (   st.tn IN
                                       (SELECT slave
                                          FROM full
                                         WHERE master =
                                                  DECODE (
                                                     :tn,
                                                     -1, (SELECT MAX (tn)
                                                            FROM user_list
                                                           WHERE is_admin = 1),
                                                     :tn))
                                 OR (SELECT NVL (is_traid, 0)
                                       FROM user_list
                                      WHERE tn =
                                               DECODE (
                                                  :tn,
                                                  -1, (SELECT MAX (tn)
                                                         FROM user_list
                                                        WHERE is_admin = 1),
                                                  :tn)) = 1)
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
                    AND st.tn IN
                           (SELECT slave
                              FROM full
                             WHERE master =
                                      DECODE (
                                         :exp_list_without_ts,
                                         0, DECODE (:tn,
                                                    -1, (SELECT MAX (tn)
                                                           FROM user_list
                                                          WHERE is_admin = 1),
                                                    :tn),
                                         :exp_list_without_ts))
                    AND st.tn IN
                           (SELECT slave
                              FROM full
                             WHERE master =
                                      DECODE (
                                         :exp_list_only_ts,
                                         0, DECODE (:tn,
                                                    -1, (SELECT MAX (tn)
                                                           FROM user_list
                                                          WHERE is_admin = 1),
                                                    :tn),
                                         :exp_list_only_ts))
                    AND (   st.tn IN
                               (SELECT slave
                                  FROM full
                                 WHERE master =
                                          DECODE (:tn,
                                                  -1, (SELECT MAX (tn)
                                                         FROM user_list
                                                        WHERE is_admin = 1),
                                                  :tn))
                         OR (SELECT NVL (is_traid, 0)
                               FROM user_list
                              WHERE tn = DECODE (:tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn)) = 1)
                    AND st.dpt_id = :dpt_id
                    AND DECODE (:eta_list, '', tp.h_fio_eta, :eta_list) =
                           tp.h_fio_eta
                    AND tp.tp_kod = vo.tp_kod(+)
                    AND tp.tp_kod = nv.tp_kod(+)
                    AND tp.tp_kod = tps.tp_kod(+))
   GROUP BY act,
            m,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn