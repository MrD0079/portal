/* Formatted on 26/11/2014 17:28:46 (QP5 v5.227.12220.39724) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod_key,
         d.nakl,
         d.saleszefir,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         d.sales,
         CASE WHEN d.saleszefir >= 2 THEN 1 ELSE 0 END if1,
         NVL (an.if1, 0) selected_if1,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE tn = (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            ok_chief,
         an.bonus_sum1,
         d.H_tp_kod_key_DATA_NAKL
    FROM a1411z d, a1411z_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.tp_kod_key, :tp) = d.tp_kod_key
         AND DECODE (:tp, 0, d.H_tp_kod_key_DATA_NAKL, 0) =
                DECODE (:tp, 0, an.H_tp_kod_key_DATA_NAKL, 0)
         AND d.H_tp_kod_key_DATA_NAKL = an.H_tp_kod_key_DATA_NAKL(+)
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:tp, 0, DECODE (NVL (an.if1, 0), 0, 0, 1), 0) =
                DECODE (:tp, 0, 1, 0)
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl