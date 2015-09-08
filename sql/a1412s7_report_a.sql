/* Formatted on 28/01/2015 9:45:30 (QP5 v5.227.12220.39724) */
  SELECT d.h_tp_kod_data_nakl,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.summnds,
         d.truf,
         d.sharm,
         d.TRUFE,
         d.other,
         TRUNC ( (d.TRUF + d.SHARM + d.TRUFE + d.OTHER) / 7) cond_cnt,
         LEAST (TRUNC ( (d.TRUF + d.SHARM + d.TRUFE + d.OTHER) / 7), 2) * 83
            max_bonus,
         NULL bonus_plan,
         d.tp_addr,
         CASE WHEN d.TRUF + d.SHARM + d.TRUFE + d.OTHER >= 7 THEN 1 ELSE 0 END
            if1,
         NVL (an.id, 0) selected_if1,
         an.bonus_sum1,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
                  (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

            ok_chief_date,
                  (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

            ok_chief,
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
    FROM a1412s7 d,
         a1412s7_action_nakl an,
         user_list st,
         a1412s7_tp_select tp
   WHERE     d.tab_num = st.tab_num
         AND st.dpt_id = :dpt_id
         AND d.h_tp_kod_data_nakl = an.h_tp_kod_data_nakl(+)
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND st.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND st.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, master,
                                   :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_bonus,
                        1, 0,
                        2, DECODE (an.bonus_dt1, NULL, 0, 1),
                        3, DECODE (an.bonus_dt1, NULL, 0, 1))
         AND DECODE (:is_act,  1, 0,  2, 1,  3, 0) =
                DECODE (
                   :is_act,
                   1, 0,
                   2, CASE
                         WHEN d.TRUF + d.SHARM + d.TRUFE + d.OTHER >= 7 THEN 1
                         ELSE 0
                      END,
                   3, CASE
                         WHEN d.TRUF + d.SHARM + d.TRUFE + d.OTHER >= 7 THEN 1
                         ELSE 0
                      END)
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl