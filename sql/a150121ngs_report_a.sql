/* Formatted on 29/01/2015 12:11:41 (QP5 v5.227.12220.39724) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.nakl_summ,
         d.NG_Shoko_Summ,
         d.NG_Shoko_Summ / 1.9 max_bonus,
         d.tp_addr,
         NVL (an.if1, 0) selected_if1,
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
    FROM a150121ngs d,
         a150121ngs_action_nakl an,
         user_list st,
         a150121ngs_tp_select tp
   WHERE     d.tab_num = st.tab_num
         AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND an.if1 = 1
         AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_bonus,
                        1, 0,
                        2, DECODE (an.bonus_dt1, NULL, 0, 1),
                        3, DECODE (an.bonus_dt1, NULL, 0, 1))
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl