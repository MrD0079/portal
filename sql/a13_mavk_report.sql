/* Formatted on 03/06/2013 12:33:09 (QP5 v5.227.12220.39724) */
  SELECT an.id,
         d.h_tp_kod_data_nakl,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.summa,
         d.tp_addr,
         an.bonus_sum,
         TO_CHAR (an.bonus_dt, 'dd.mm.yyyy') bonus_dt,
         TO_CHAR (an.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
         TO_CHAR (an.ok_traid_date, 'dd.mm.yyyy hh24:mi:ss') ok_traid_date,
         an.ok_chief,
         an.ok_traid,
         an.ok_traid_tn,
         fn_getname ( an.ok_traid_tn) traid_fio,
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
         st.tn ts_tn,
         d.SummShokVes,
         d.SummPechVes,
         an.condition,
         CASE
            WHEN an.condition = 4 THEN 800
            WHEN an.condition = 3 THEN 250
            WHEN an.condition = 2 THEN 200
            WHEN an.condition = 1 THEN 120
         END
            max_bonus_2,
         CASE
            WHEN an.condition = 4 THEN 0
            WHEN an.condition = 3 THEN 0
            WHEN an.condition = 2 THEN 120
            WHEN an.condition = 1 THEN 60
         END
            max_bonus_3,
         an.bonus_type
    FROM a13_mavk d,
         a13_mavk_action_nakl an,
         user_list st,
         a13_mavk_tp_select tp
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
         AND DECODE (:ok_traid,  1, 0,  2, 1) =
                DECODE (:ok_traid,  1, 0,  2, an.ok_traid)
         AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_ts,
                        1, 0,
                        2, DECODE (an.bonus_dt, NULL, 0, 1),
                        3, DECODE (an.bonus_dt, NULL, 0, 1))
         AND DECODE (:bonus_type, 1, 0, :bonus_type) =
                DECODE (:bonus_type, 1, 0, an.bonus_type)
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl