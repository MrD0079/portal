/* Formatted on 28/08/2015 9:53:35 (QP5 v5.227.12220.39724) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         d.act_summ,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         d.nakl_summ,
         CASE WHEN d.act_summ >= f.flag * 500 THEN 1 ELSE 0 END if1,
         NVL (an.if1, 0) selected_if1,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief,
         an.bonus_sum1,
         d.H_TP_KOD_DATA_NAKL,
         DECODE ( (SELECT COUNT (*)
                     FROM (SELECT h_tp_kod_data_nakl FROM a1504ap_action_nakl
                           UNION
                           SELECT h_tp_kod_data_nakl FROM a1504cy_action_nakl)
                    WHERE h_tp_kod_data_nakl = d.H_TP_KOD_DATA_NAKL),
                 0, 0,
                 1)
            nakl_already_selected,
         f.flag
    FROM a1508kzp d,
         a1508kzp_action_nakl an,
         user_list st,
         a1508kzp_flag f
   WHERE     d.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, d.H_TP_KOD_DATA_NAKL, 0) =
                DECODE (:tp, 0, an.H_TP_KOD_DATA_NAKL, 0)
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:tp, 0, DECODE (NVL (an.if1, 0), 0, 0, 1), 0) =
                DECODE (:tp, 0, 1, 0)
         AND d.tp_kod = f.tp_kod
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl