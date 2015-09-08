/* Formatted on 11.01.2013 13:25:36 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         an.id,
         an.summa,
         an.bonus,
         an.bonus_plan,
         TO_CHAR (an.DATA, 'dd.mm.yyyy') data,
         an.id,
         an.tn_ts,
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
         an.ok_traid,
         an.ok_ts,
         TO_CHAR (an.ok_super_date, 'dd.mm.yyyy') ok_super_date,
         fn_getname ( an.ok_super_tn) ok_super_name,
         maytps.contact_lpr,
         (SELECT name
            FROM may_types
           WHERE id = an.TYPE)
            TYPE,
         DECODE (NVL (an.summa, 0), 0, 0, an.bonus / an.summa * 100) perc
    FROM may_tp_select maytps,
         (SELECT DISTINCT tab_number tab_num,
                          ts fio_ts,
                          eta fio_eta,
                          tp_name tp_ur,
                          address tp_addr,
                          tp_kod
            FROM may) d,
         may_action_nakl an,
         spdtree st
   WHERE     d.tab_num = st.tab_num
         AND d.tp_kod = maytps.tp_kod
         AND d.fio_eta = maytps.fio_eta
         AND d.tp_kod = an.tp_kod
         AND d.fio_eta = an.fio_eta
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
         AND st.dpt_id = :dpt_id
ORDER BY d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         an.id