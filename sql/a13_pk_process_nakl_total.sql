/* Formatted on 21.03.2013 16:30:46 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c1,
         SUM (d.summa) summa,
         SUM (d.qskuw) qskuw,
         SUM (d.sskuw) sskuw,
         SUM (an.bonus_sum) bonus_sum
    FROM a13_pk d, a13_pk_action_nakl an, user_list st
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
         AND DECODE (:tp, 0, DECODE (NVL (an.if1, 0), 0, 0, 1), 0) = DECODE (:tp, 0, 1, 0)
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl