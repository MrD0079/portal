/* Formatted on 25.09.2013 11:38:39 (QP5 v5.227.12220.39724) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.summa,
         d.cond1,
         d.cond2,
         d.cond3,
         d.sumveskonf,
         CASE
            WHEN d.cond1 = 1 OR (d.sumveskonf >= 1400 AND d.sumveskonf < 1800)
            THEN
               1
            ELSE
               0
         END
            c1,
         CASE
            WHEN d.cond2 = 1 OR (d.sumveskonf >= 1800 AND d.sumveskonf < 2300)
            THEN
               1
            ELSE
               0
         END
            c2,
         CASE WHEN d.cond3 = 1 OR (d.sumveskonf >= 2300) THEN 1 ELSE 0 END c3,
         CASE
            WHEN d.cond3 = 1 OR (d.sumveskonf >= 2300)
            THEN
               3
            WHEN d.cond2 = 1 OR (d.sumveskonf >= 1800 AND d.sumveskonf < 2300)
            THEN
               2
            WHEN d.cond1 = 1 OR (d.sumveskonf >= 1400 AND d.sumveskonf < 1800)
            THEN
               1
            ELSE
               0
         END
            c,
         d.tp_addr,
         NVL (an.if1, 0) selected_if1,
         an.bonus_sum1,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         TO_CHAR (an.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
         TO_CHAR (an.ok_traid_date, 'dd.mm.yyyy hh24:mi:ss') ok_traid_date,
         an.ok_chief,
         an.ok_traid,
         an.ok_traid_fio,
         NVL (an.ok_chief_fio,
              fn_getname (
                           (SELECT parent
                              FROM parents
                             WHERE tn = st.tn)))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM a13_sv9 d,
         a13_sv9_action_nakl an,
         user_list st,
         a13_sv9_tp_select tp
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts,
                                     0, DECODE (:tn,
                                                -1, (SELECT MAX (tn)
                                                       FROM user_list
                                                      WHERE is_admin = 1),
                                                :tn),
                                     :exp_list_without_ts))
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts,
                                     0, DECODE (:tn,
                                                -1, (SELECT MAX (tn)
                                                       FROM user_list
                                                      WHERE is_admin = 1),
                                                :tn),
                                     :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn,
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
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_chief,
                        1, 0,
                        2, an.ok_chief,
                        3, NVL (an.ok_chief, 0))
         /*AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.data, 'mm'))*/
         AND DECODE (NVL (an.if1, 0), 0, 0, 1) = 1
/*AND d.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl