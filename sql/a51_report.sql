/* Formatted on 11.01.2013 14:03:38 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         REPLACE (d.nakl, ' ', '') nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.summa,
         d.action_qt_ya,
         d.action_sum,
         d.action_qt_sku,
         CASE WHEN d.action_qt_ya >= 5 THEN 1 END action_nakl,
         TRUNC (d.action_qt_ya / 5) max_ya,
         DECODE (an.nakl, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         ya fakt_ya,
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
         a51tps.contact_lpr
    FROM a51_tp_select a51tps,
         a51 d,
         a51_action_nakl an,
         spdtree st
   WHERE     d.tab_num = st.tab_num
         AND d.tp_kod = a51tps.tp_kod(+)
         AND d.fio_eta = a51tps.fio_eta(+)
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl
         AND d.tp_kod = an.tp_kod(+)
         AND d.fio_eta = an.fio_eta(+)
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl(+)
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND DECODE (:ok_traid,  1, 0,  2, 1,  3, 0) = DECODE (:ok_traid,  1, 0,  2, an.ok_traid,  3, NVL (an.ok_traid, 0))
         AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts, 1, 0, an.ok_ts)
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief, 1, 0, an.ok_chief)
         AND DECODE (:giveup_check, 0, 0, NVL (an.ok_ts, 0)) = :giveup_check
         AND DECODE (:per,  1, SYSDATE,  2, TO_DATE ('01.03.2012', 'dd/mm/yyyy'),  3, TO_DATE ('01.04.2012', 'dd/mm/yyyy')) = DECODE (:per, 1, SYSDATE, TRUNC (d.data, 'mm'))
         AND st.dpt_id = :dpt_id
ORDER BY d.data, REPLACE (d.nakl, ' ', '')