/* Formatted on 12.07.2013 9:22:14 (QP5 v5.227.12220.39724) */
  SELECT an.id,
         nvl(an.if1, 0) selected_if1,
         nvl(an.if2, 0) selected_if2,
         d.h_tp_kod_data_nakl,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.summa,
         /*DECODE (st.region_name, 'Запад', GREATEST (d.summa * 0.2, 90), 90)*/
         145   bonus_max1,
         /*DECODE (st.region_name, 'Запад', GREATEST (d.summa * 0.2, 87), 87)*/
         77   bonus_max2,
         d.tp_addr,
         an.bonus_sum1,
         an.bonus_sum2,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         TO_CHAR (an.bonus_dt2, 'dd.mm.yyyy') bonus_dt2,
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
         st.region_name
    FROM a13_ss8 d,
         a13_ss8_action_nakl an,
         user_list st,
         a13_ss8_tp_select tp
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
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl