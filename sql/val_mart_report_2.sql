/* Formatted on 11.01.2013 13:53:39 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         REPLACE (d.nakl, ' ', '') nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.summa,
         CASE WHEN d.summa >= 1250 THEN 1 END action_nakl,
         TRUNC (d.summa / 1250) max_ya,
         DECODE (an.nakl, NULL, 0, 1) selected,
         ya ya_gel,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         TO_CHAR (an.ok_ts_date, 'dd.mm.yyyy') ok_ts_date,
         st.svideninn,
         (SELECT exp_tn
            FROM emp_exp
           WHERE full = 1 AND emp_tn = st.svideninn)
            parent_tn,
         fn_getname (
                      (SELECT exp_tn
                         FROM emp_exp
                        WHERE full = 1 AND emp_tn = st.svideninn))
            parent_fio,
         (SELECT exp_tn
            FROM emp_exp
           WHERE emp_tn = st.svideninn AND full = 0 AND emp_tn <> exp_tn AND exp_tn = :tn)
            ts_exp_not_full,
         an.ok_ts_exp_not_full,
         TO_CHAR (an.ok_ts_exp_not_full_date, 'dd.mm.yyyy') ok_ts_exp_not_full_date,
         fn_getname ( an.ok_ts_exp_not_full_tn) ok_ts_exp_not_full_name,
         an.ok_super,
         TO_CHAR (an.ok_super_date, 'dd.mm.yyyy') ok_super_date,
         fn_getname ( an.ok_super_tn) ok_super_name,
         vmts.contact_lpr
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
         AND d.tp_kod = an.tp_kod                                                                                                                                                                  --(+)
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl                                                                                                                                            --(+)
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