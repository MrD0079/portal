/* Formatted on 11.01.2013 13:53:51 (QP5 v5.163.1008.3004) */
  SELECT COUNT (DISTINCT REPLACE (d.nakl, ' ', '')) nakl,
         COUNT (DISTINCT d.tp_kod) tp_kod,
         SUM (d.summa) summa,
         SUM (ya) ya_gel
    FROM val_mart_tp_select vmts,
         val_mart d,
         val_mart_action_nakl an,
         spdtree st
   WHERE     d.tab_num = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND d.tp_kod = vmts.tp_kod
         AND vmts.tp_kat = :tp_kat
         AND vmts.selected = 1
         AND d.tp_kod = an.tp_kod
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl
         AND DECODE (:ok_traid,  1, 0,  2, 1,  3, 0) = DECODE (:ok_traid,  1, 0,  2, an.ok_traid,  3, NVL (an.ok_traid, 0))
         AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts, 1, 0, an.ok_ts)
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief, 1, 0, an.ok_chief)
         AND DECODE (:giveup_check, 0, 0, NVL (an.ok_ts, 0)) = :giveup_check
         AND st.dpt_id = :dpt_id
ORDER BY d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.data,
         d.nakl