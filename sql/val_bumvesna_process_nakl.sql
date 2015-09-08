/* Formatted on 21.03.2013 16:31:13 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt, 'dd.mm.yyyy') bonus_dt,
         d.summa,
         d.packveskonf,
         d.SUMmshok,
         d.SUMMvespech,
         CASE WHEN d.packveskonf >= 7 THEN 1 ELSE 0 END if1,
         CASE WHEN d.SUMMvespech >= 345 THEN 1 ELSE 0 END if2,
         NVL (an.if1, 0) selected_if1,
         NVL (an.if2, 0) selected_if2,
         an.ok_traid,
         an.ok_chief,
         an.bonus_sum,
         d.H_TP_KOD_DATA_NAKL
    FROM val_bumvesna d, val_bumvesna_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, d.H_TP_KOD_DATA_NAKL, 0) = DECODE (:tp, 0, an.H_TP_KOD_DATA_NAKL, 0)
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:tp, 0, DECODE (NVL (an.if1, 0) + NVL (an.if2, 0), 0, 0, 1), 0) = DECODE (:tp, 0, 1, 0)
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl