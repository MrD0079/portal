/* Formatted on 28.05.2013 15:23:13 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c,
       COUNT (*) - SUM (is_act) is_not_act,
       SUM (is_act) is_act,
       SUM (DECODE (is_act, 1, bonus_plan, 0)) bonus_plan,
       SUM (DECODE (is_act, 1, fakt_bonus, 0)) fakt_bonus,
       SUM (ok_ts) ok_ts,
       SUM (ok_chief) ok_chief,
       DECODE (NVL (SUM (DECODE (is_act, 1, summa_prev + summa, 0)), 0), 0, 0, SUM (DECODE (is_act, 1, fakt_bonus, 0)) / SUM (DECODE (is_act, 1, summa_prev + summa, 0)) * 100) act_uah,
       SUM (summa_prev) summa_prev,
       SUM (summa) summa,
       DECODE (
          SIGN (
             DECODE (SIGN (DECODE (SUM (summa_prev), 0, 0, SUM (summa) / SUM (summa_prev) * 100 - 100)), 1, DECODE (SUM (summa_prev), 0, 0, SUM (summa) / SUM (summa_prev) * 100 - 100), 0)
             - DECODE (:month,  2, 40,  3, 50,  4, 30)),
          -1, DECODE (SIGN (DECODE (SUM (summa_prev), 0, 0, SUM (summa) / SUM (summa_prev) * 100 - 100)), 1, DECODE (SUM (summa_prev), 0, 0, SUM (summa) / SUM (summa_prev) * 100 - 100), 0),
          DECODE (:month,  2, 40,  3, 50,  4, 30))
          rost_perc,
       AVG ( (SELECT SUM (bonus)
                FROM val_vesna_files st
               WHERE     st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                     AND st.m = :month))
          files_bonus_total,
       AVG ( (SELECT SUM (bonus)
                FROM val_vesna_files st
               WHERE     st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                     AND st.m = :month
                     AND ok_traid = 1))
          files_bonus_traid
  FROM (SELECT z1.*, DECODE (SIGN (rost_perc - 20), -1, 0, 1) is_act
          FROM (SELECT z.*,
                       DECODE (
                          SIGN (
                             DECODE (SIGN (DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100)), 1, DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100), 0)
                             - DECODE (:month,  2, 40,  3, 50,  4, 30)),
                          -1, DECODE (SIGN (DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100)), 1, DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100), 0),
                          DECODE (:month,  2, 40,  3, 50,  4, 30))
                          rost_perc,
                       DECODE (SIGN (summa - summa_prev), 1, summa - summa_prev, 0) rost_uah,
                       DECODE (
                          SIGN (
                             DECODE (SIGN (DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100)), 1, DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100), 0)
                             - DECODE (:month,  2, 40,  3, 50,  4, 30)),
                          -1, DECODE (SIGN (DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100)), 1, DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100), 0),
                          DECODE (:month,  2, 40,  3, 50,  4, 30))
                       * summa_prev
                       * 0.2
                       / 100
                          bonus_plan
                  FROM (  SELECT v.tab_num,
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
                                 v1.summa_prev,
                                 SUM (DECODE (TRUNC (v.data, 'mm'), TO_DATE ('01.' || TO_CHAR (:month) || '.2013', 'dd.mm.yyyy'), summa, 0)) summa,
                                 vtps.fakt_bonus,
                                 vtps.ok_traid,
                                 vtps.ok_ts,
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
                                 (SELECT SUM (bonus)
                                    FROM val_vesna_files
                                   WHERE tn = st.tn)
                                    files_bonus_total,
                                 (SELECT COUNT (*)
                                    FROM val_vesna_files
                                   WHERE tn = st.tn AND ok_traid = 1)
                                    files_bonus_traid
                            FROM val_vesna_tp_select vtps,
                                 val_vesna v,
                                 user_list st,
                                 creamcherry_action_nakl cc,
                                 --val_bumvesna_tp_select vb,
                                 choco_action_nakl ch,
                                 (  SELECT tp_kod, SUM (summa) summa_prev
                                      FROM val_vesna
                                     WHERE TRUNC (data, 'mm') = TO_DATE ('01.' || TO_CHAR (:month - 1) || '.2013', 'dd.mm.yyyy')
                                  GROUP BY tp_kod) v1
                           WHERE     v.tab_num = st.tab_num
                                 AND v.tp_kod = v1.tp_kod(+)
                                 AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                                 AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                                 AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                                 AND v.tp_kod = vtps.tp_kod
                                 AND st.dpt_id = :dpt_id
                                 AND vtps.selected = 1
                                 AND v.h_tp_kod_data_nakl = cc.h_tp_kod_data_nakl(+)
                                 --AND v.tp_kod = vb.tp_kod(+)
                                 AND v.h_tp_kod_data_nakl = ch.h_tp_kod_data_nakl(+)
                                 AND vtps.m = :month
                                 AND (cc.h_tp_kod_data_nakl IS NULL OR DECODE (NVL (cc.if1, 0) + NVL (cc.if2, 0), 0, 0, 1) = 0)
                                 --AND NVL (vb.selected, 0) = 0
                                 AND ch.h_tp_kod_data_nakl IS NULL
                                 AND TRUNC (v.data, 'mm') = TO_DATE ('01.' || TO_CHAR (:month) || '.2013', 'dd.mm.yyyy')
                        GROUP BY v.tab_num,
                                 st.fio,
                                 v.fio_eta,
                                 v.tp_ur,
                                 v.tp_addr,
                                 v.tp_kod,
                                 vtps.selected,
                                 vtps.contact_lpr,
                                 vtps.fakt_bonus,
                                 vtps.ok_traid,
                                 vtps.ok_ts,
                                 vtps.ok_chief,
                                 vtps.ok_ts_date,
                                 vtps.ok_chief_date,
                                 st.tn,
                                 v1.summa_prev) z) z1)