/* Formatted on 21/09/2015 17:43:53 (QP5 v5.227.12220.39724) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.nakl_summ,
         d.act_summ,
         TRUNC (d.act_summ / 4) * 21 max_bonus,
         d.tp_addr,
         NVL (an.if1, 0) selected_if1,
         an.bonus_sum1,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief_date,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief,
         fn_getname ( (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM a1509vs d,
         a1509vs_action_nakl an,
         user_list st,
         a1509vs_tp_select tp,
         a1509vs_flag f
   WHERE     d.tab_num = st.tab_num
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
         AND st.dpt_id = :dpt_id
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND an.if1 = 1
         AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_bonus,
                        1, 0,
                        2, DECODE (an.bonus_dt1, NULL, 0, 1),
                        3, DECODE (an.bonus_dt1, NULL, 0, 1))
         AND d.tp_kod = f.tp_kod(+) and f.tp_kod is null
         AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = :month
         AND tp.m = :month
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl