/* Formatted on 05.02.2013 17:28:54 (QP5 v5.163.1008.3004) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.qtysku,
         d.summnds_pg,
         d.tp_kod,
         d.tp_ur,
         d.summa,
         d.tp_addr,
         an.bonus_d_qty,
         an.bonus_t_qty,
         an.bonus_d_fact,
         an.bonus_t_fact,
         an.ok_ts,
         TO_CHAR (an.ok_ts_date, 'dd.mm.yyyy') ok_ts_date,
         TO_CHAR (an.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
         an.ok_chief,
         an.ok_traid,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM choco_box d,
         choco_action_nakl an,
         user_list st,
         choco_tp_select tp
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
                           AND DECODE (:ok_traid,  1, 0,  2, 1) = DECODE (:ok_traid,  1, 0,  2, an.ok_traid)
                           AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts,  1, 0,  2, an.ok_ts,  3, NVL (an.ok_ts, 0))
                           AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief,  1, 0,  2, an.ok_chief,  3, NVL (an.ok_chief, 0))
                           AND DECODE (:act_month,  0, 0,  :act_month) = DECODE (:act_month,  0, 0,  TO_NUMBER (TO_CHAR (d.data, 'mm')))
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl