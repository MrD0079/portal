/* Formatted on 03.01.2014 10:15:20 (QP5 v5.227.12220.39724) */
  SELECT v.tab_num,
         st.fio fio_ts,
         v.fio_eta,
         v.tp_ur,
         v.tp_addr,
         v.tp_kod,
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
            summa,
         CASE
            WHEN CASE
                    WHEN :month = 10
                    THEN
                       NVL (v.s10, 0) - NVL (oh.summa, 0) - NVL (v.s1_9, 0)
                    WHEN :month = 11
                    THEN
                         NVL (v.s11, 0)
                       - NVL (nh.summa, 0)
                       - NVL (yc.summa, 0)
                       - NVL (s10f, 0)
                    WHEN :month = 12
                    THEN
                         NVL (v.s12, 0)
                       - NVL (hc.summa, 0)
                       - NVL (oy.summa, 0)
                       - NVL (sn.summa, 0)
                       - NVL (v.s11, 0)
                 END > 0
            THEN
               CASE
                  WHEN :month = 10
                  THEN
                     NVL (v.s10, 0) - NVL (oh.summa, 0) - NVL (v.s1_9, 0)
                  WHEN :month = 11
                  THEN
                       NVL (v.s11, 0)
                     - NVL (nh.summa, 0)
                     - NVL (yc.summa, 0)
                     - NVL (s10f, 0)
                  WHEN :month = 12
                  THEN
                       NVL (v.s12, 0)
                     - NVL (hc.summa, 0)
                     - NVL (oy.summa, 0)
                     - NVL (sn.summa, 0)
                     - NVL (v.s11, 0)
               END
         END
            rost_uah,
         CASE
            WHEN CASE
                    WHEN :month = 10
                    THEN
                       NVL (v.s10, 0) - NVL (oh.summa, 0) - NVL (v.s1_9, 0)
                    WHEN :month = 11
                    THEN
                         NVL (v.s11, 0)
                       - NVL (nh.summa, 0)
                       - NVL (yc.summa, 0)
                       - NVL (s10f, 0)
                    WHEN :month = 12
                    THEN
                         NVL (v.s12, 0)
                       - NVL (hc.summa, 0)
                       - NVL (oy.summa, 0)
                       - NVL (sn.summa, 0)
                       - NVL (v.s11, 0)
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
                 END >=
                    CASE
                       WHEN :month = 10 THEN 10000
                       WHEN :month = 11 THEN 15000
                       WHEN :month = 12 THEN 15000
                       WHEN :month = 13 THEN 50000
                    END
            THEN
               1
            ELSE
               0
         END
            is_act,
         TRUNC (
              (CASE
                  WHEN CASE
                          WHEN :month = 10
                          THEN
                               NVL (v.s10, 0)
                             - NVL (oh.summa, 0)
                             - NVL (v.s1_9, 0)
                          WHEN :month = 11
                          THEN
                               NVL (v.s11, 0)
                             - NVL (nh.summa, 0)
                             - NVL (yc.summa, 0)
                             - NVL (s10f, 0)
                          WHEN :month = 12
                          THEN
                               NVL (v.s12, 0)
                             - NVL (hc.summa, 0)
                             - NVL (oy.summa, 0)
                             - NVL (sn.summa, 0)
                             - NVL (v.s11, 0)
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
                       END > 0
                  THEN
                     CASE
                        WHEN :month = 10
                        THEN
                           NVL (v.s10, 0) - NVL (oh.summa, 0) - NVL (v.s1_9, 0)
                        WHEN :month = 11
                        THEN
                             NVL (v.s11, 0)
                           - NVL (nh.summa, 0)
                           - NVL (yc.summa, 0)
                           - NVL (s10f, 0)
                        WHEN :month = 12
                        THEN
                             NVL (v.s12, 0)
                           - NVL (hc.summa, 0)
                           - NVL (oy.summa, 0)
                           - NVL (sn.summa, 0)
                           - NVL (v.s11, 0)
                        WHEN :month = 13
                        THEN
                           CASE
                              WHEN   NVL (v.s10, 0)
                                   - NVL (oh.summa, 0)
                                   + NVL (v.s11, 0)
                                   - NVL (nh.summa, 0)
                                   - NVL (yc.summa, 0)
                                   + NVL (v.s12, 0)
                                   - NVL (hc.summa, 0)
                                   - NVL (oy.summa, 0)
                                   - NVL (sn.summa, 0) >= 50000
                              THEN
                                 1
                              ELSE
                                 0
                           END
                     END
               END)
            / CASE
                 WHEN :month = 10 THEN 10000
                 WHEN :month = 11 THEN 15000
                 WHEN :month = 12 THEN 15000
                 WHEN :month = 13 THEN 1
              END)
            max_bonus,
         vtps.ok_traid,
         vtps.ok_chief,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         TO_CHAR (vtps.ok_ts_date, 'dd.mm.yyyy') ok_ts_date,
         TO_CHAR (vtps.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
         st.tn,
         vtps.bonus1,
         vtps.bonus2,
         vtps.bonus3,
         vtps.bonus4,
         vtps.bonus5,
         vtps.bonus6,
         vtps.bonus7,
         vtps.bonus8,
         vtps.bonus9,
         CASE
            WHEN      NVL (vtps.bonus1, 0)
                    + NVL (vtps.bonus2, 0)
                    + NVL (vtps.bonus3, 0)
                    + NVL (vtps.bonus5, 0)
                    + NVL (vtps.bonus6, 0)
                    + NVL (vtps.bonus7, 0)
                    + NVL (vtps.bonus8, 0)
                    + NVL (vtps.bonus9, 0) >
                       TRUNC (
                            (CASE
                                WHEN CASE
                                        WHEN :month = 10
                                        THEN
                                             NVL (v.s10, 0)
                                           - NVL (oh.summa, 0)
                                           - NVL (v.s1_9, 0)
                                        WHEN :month = 11
                                        THEN
                                             NVL (v.s11, 0)
                                           - NVL (nh.summa, 0)
                                           - NVL (yc.summa, 0)
                                           - NVL (s10f, 0)
                                        WHEN :month = 12
                                        THEN
                                             NVL (v.s12, 0)
                                           - NVL (hc.summa, 0)
                                           - NVL (oy.summa, 0)
                                           - NVL (sn.summa, 0)
                                           - NVL (v.s11, 0)
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
                                     END > 0
                                THEN
                                   CASE
                                      WHEN :month = 10
                                      THEN
                                           NVL (v.s10, 0)
                                         - NVL (oh.summa, 0)
                                         - NVL (v.s1_9, 0)
                                      WHEN :month = 11
                                      THEN
                                           NVL (v.s11, 0)
                                         - NVL (nh.summa, 0)
                                         - NVL (yc.summa, 0)
                                         - NVL (s10f, 0)
                                      WHEN :month = 12
                                      THEN
                                           NVL (v.s12, 0)
                                         - NVL (hc.summa, 0)
                                         - NVL (oy.summa, 0)
                                         - NVL (sn.summa, 0)
                                         - NVL (v.s11, 0)
                                      WHEN :month = 13
                                      THEN
                                         CASE
                                            WHEN   NVL (v.s10, 0)
                                                 - NVL (oh.summa, 0)
                                                 + NVL (v.s11, 0)
                                                 - NVL (nh.summa, 0)
                                                 - NVL (yc.summa, 0)
                                                 + NVL (v.s12, 0)
                                                 - NVL (hc.summa, 0)
                                                 - NVL (oy.summa, 0)
                                                 - NVL (sn.summa, 0) >= 50000
                                            THEN
                                               1
                                            ELSE
                                               0
                                         END
                                   END
                             END)
                          / CASE
                               WHEN :month = 10 THEN 10000
                               WHEN :month = 11 THEN 15000
                               WHEN :month = 12 THEN 15000
                               WHEN :month = 13 THEN 1
                            END)
                 OR vtps.bonus4 >
                         CASE
                            WHEN :month = 10
                            THEN
                               NVL (v.s10, 0) - NVL (oh.summa, 0)
                            WHEN :month = 11
                            THEN
                                 NVL (v.s11, 0)
                               - NVL (nh.summa, 0)
                               - NVL (yc.summa, 0)
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
                       * 0.07
            THEN
               1
            ELSE
               0
         END
            is_red
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
                   AND OH.DATA BETWEEN TO_DATE ('14.10.2013', 'dd.mm.yyyy')
                                   AND TO_DATE ('31.10.2013', 'dd.mm.yyyy')
          GROUP BY oh.tp_kod) oh,
         (  SELECT nh.tp_kod, SUM (summa) summa
              FROM a13_nh nh, a13_nh_tp_select nh_tp, a13_nh_action_nakl nh_an
             WHERE     nh.tp_kod = nh_tp.tp_kod
                   AND nh_tp.selected = 1
                   AND nh.H_TP_KOD_DATA_NAKL = nh_AN.H_TP_KOD_DATA_NAKL
                   AND nh_an.if1 = 1
          GROUP BY nh.tp_kod) nh,
         (  SELECT nh.tp_kod, SUM (summa) summa
              FROM a13_yc nh, a13_yc_tp_select nh_tp, a13_yc_action_nakl nh_an
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
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, :tn,
                                   :exp_list_without_ts))
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, :tn,
                                   :exp_list_only_ts))
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND v.tp_kod = vtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND vtps.selected = 1
         /*AND DECODE (:ok_traid,  1, 0,  2, 1) =
                DECODE (:ok_traid,  1, 0,  2, vtps.ok_traid)*/
         AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_ts, 1, 0, DECODE (vtps.ok_ts_date, NULL, 0, 1))
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_chief,
                        1, 0,
                        2, vtps.ok_chief,
                        3, NVL (vtps.ok_chief, 0))
         AND DECODE (:is_act,  1, 0,  2, 1,  3, 0) =
                DECODE (
                   :is_act,
                   1, 0,
                   CASE
                      WHEN CASE
                              WHEN :month = 10
                              THEN
                                   NVL (v.s10, 0)
                                 - NVL (oh.summa, 0)
                                 - NVL (v.s1_9, 0)
                              WHEN :month = 11
                              THEN
                                   NVL (v.s11, 0)
                                 - NVL (nh.summa, 0)
                                 - NVL (yc.summa, 0)
                                 - NVL (s10f, 0)
                              WHEN :month = 12
                              THEN
                                   NVL (v.s12, 0)
                                 - NVL (hc.summa, 0)
                                 - NVL (oy.summa, 0)
                                 - NVL (sn.summa, 0)
                                 - NVL (v.s11, 0)
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
                           END >=
                              CASE
                                 WHEN :month = 10 THEN 10000
                                 WHEN :month = 11 THEN 15000
                                 WHEN :month = 12 THEN 15000
                                 WHEN :month = 13 THEN 50000
                              END
                      THEN
                         1
                      ELSE
                         0
                   END)
         AND v.tp_kod = vtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND vtps.selected = 1
         AND vtps.m = :month
         AND v.tp_kod = oh.tp_kod(+)
         AND v.tp_kod = nh.tp_kod(+)
         AND v.tp_kod = yc.tp_kod(+)
         AND v.tp_kod = hc.tp_kod(+)
         AND v.tp_kod = oy.tp_kod(+)
         AND v.tp_kod = sn.tp_kod(+)
ORDER BY st.fio,
         v.fio_eta,
         v.tp_ur,
         v.tp_addr