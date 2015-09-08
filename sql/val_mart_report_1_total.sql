/* Formatted on 11.01.2013 13:52:31 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       SUM (NVL (sales_fevr, 0)) sales_fevr,
       SUM (NVL (sales_mart, 0)) sales_mart,
       SUM (NVL (sales_apr, 0)) sales_apr,
       SUM (NVL (ok_traid, 0)) ok_traid,
       SUM (NVL (ok_ts, 0)) ok_ts,
       SUM (NVL (ok_chief, 0)) ok_chief,
       SUM (NVL (ok_ts_exp_not_full, 0)) ok_ts_exp_not_full,
       SUM (NVL (ok_super, 0)) ok_super,
       SUM (
          CASE
             WHEN (DECODE (NVL (sales_fevr, 0), 0, 0, ROUND (sales_mart / sales_fevr * 100, 2)) - 100) < 0 THEN 0
             ELSE (DECODE (NVL (sales_fevr, 0), 0, 0, ROUND (sales_mart / sales_fevr * 100, 2)) - 100)
          END)
          perc_mart,
       SUM (
          CASE
             WHEN (DECODE (NVL (sales_mart, 0), 0, 0, ROUND (sales_apr / sales_mart * 100, 2)) - 100) < 0 THEN 0
             ELSE (DECODE (NVL (sales_mart, 0), 0, 0, ROUND (sales_apr / sales_mart * 100, 2)) - 100)
          END)
          perc_apr,
       SUM (
          CASE
             WHEN (DECODE (NVL (sales_fevr, 0), 0, 0, ROUND ( (sales_mart + sales_apr) / (sales_fevr * 1.5) * 100, 2)) - 100) < 0 THEN 0
             ELSE (DECODE (NVL (sales_fevr, 0), 0, 0, ROUND ( (sales_mart + sales_apr) / (sales_fevr * 1.5) * 100, 2)) - 100)
          END)
          perc_total,
       SUM (CASE WHEN (sales_mart + sales_apr - sales_fevr * 1.5) < 0 THEN 0 ELSE (sales_mart + sales_apr - sales_fevr * 1.5) END) rost_total,
       SUM (CASE WHEN (sales_mart + sales_apr - sales_fevr * 1.5) / 10 < 0 THEN 0 ELSE (sales_mart + sales_apr - sales_fevr * 1.5) / 10 END) bonus
  FROM (  SELECT vm.tab_num,
                 vm.fio_ts,
                 vm.fio_eta,
                 vm.tp_ur,
                 vm.tp_addr,
                 vm.tp_kod,
                 vmts.selected,
                 vmts.contact_lpr,
                 vmk.kat_name,
                 vmts.tp_kat,
                 SUM (CASE WHEN vm.data BETWEEN TO_DATE ('01.02.2012', 'dd.mm.yyyy') AND TO_DATE ('29.02.2012', 'dd.mm.yyyy') THEN vm.summa ELSE 0 END) sales_fevr,
                 SUM (CASE WHEN vm.data BETWEEN TO_DATE ('15.03.2012', 'dd.mm.yyyy') AND TO_DATE ('31.03.2012', 'dd.mm.yyyy') THEN vm.summa ELSE 0 END) sales_mart,
                 SUM (CASE WHEN vm.data BETWEEN TO_DATE ('01.04.2012', 'dd.mm.yyyy') AND TO_DATE ('30.04.2012', 'dd.mm.yyyy') THEN vm.summa ELSE 0 END) sales_apr,
                 vmts.ok_traid,
                 vmts.ok_ts,
                 vmts.ok_chief,
                 vmts.fakt_bonus,
                 TO_CHAR (vmts.ok_ts_date, 'dd.mm.yyyy') ok_ts_date,
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
                 vmts.ok_ts_exp_not_full,
                 TO_CHAR (vmts.ok_ts_exp_not_full_date, 'dd.mm.yyyy') ok_ts_exp_not_full_date,
                 fn_getname ( vmts.ok_ts_exp_not_full_tn) ok_ts_exp_not_full_name,
                 vmts.ok_super,
                 TO_CHAR (vmts.ok_super_date, 'dd.mm.yyyy') ok_super_date,
                 fn_getname ( vmts.ok_super_tn) ok_super_name
            FROM val_mart_tp_select vmts,
                 val_mart vm,
                 spdtree st,
                 val_mart_kat vmk
           WHERE     vm.tab_num = st.tab_num
                 AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                 AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                 AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                 AND vm.tp_kod = vmts.tp_kod
                 AND vmts.tp_kat = vmk.id(+)
                 AND vmts.selected = 1
                 AND vmts.tp_kat = :tp_kat
                 AND vmts.selected = 1
                 AND DECODE (:ok_traid,  1, 0,  2, 1,  3, 0) = DECODE (:ok_traid,  1, 0,  2, vmts.ok_traid,  3, NVL (vmts.ok_traid, 0))
                 AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts, 1, 0, vmts.ok_ts)
                 AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief, 1, 0, vmts.ok_chief)
                 AND DECODE (:giveup_check, 0, 0, NVL (vmts.ok_ts, 0)) = :giveup_check
                 AND st.dpt_id = :dpt_id
        GROUP BY vm.tab_num,
                 vm.fio_ts,
                 vm.fio_eta,
                 vm.tp_ur,
                 vm.tp_addr,
                 vm.tp_kod,
                 vmts.selected,
                 vmts.contact_lpr,
                 vmk.kat_name,
                 vmts.tp_kat,
                 vmts.ok_traid,
                 vmts.ok_ts,
                 vmts.ok_chief,
                 vmts.fakt_bonus,
                 vmts.ok_ts_date,
                 st.svideninn,
                 vmts.ok_ts_exp_not_full,
                 vmts.ok_ts_exp_not_full_date,
                 vmts.ok_ts_exp_not_full_tn,
                 vmts.ok_super,
                 vmts.ok_super_date,
                 vmts.ok_super_tn) z