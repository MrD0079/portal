/* Formatted on 30.08.2013 9:55:53 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c1,
         SUM (d.summa) summa,
         SUM (d.ShelMix) ShelMix,
         /*SUM (d.CHER420Q) CHER420Q,*/
         SUM (an.bonus_sum1) bonus_sum1,
         SUM (an.bonus_sum2) bonus_sum2
    FROM a13_sm8 d, a13_sm8_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, d.H_TP_KOD_DATA_NAKL, 0) =
                DECODE (:tp, 0, an.H_TP_KOD_DATA_NAKL, 0)
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:tp,
                     0, DECODE (NVL (an.if1, 0) + NVL (an.if2, 0), 0, 0, 1),
                     0) = DECODE (:tp, 0, 1, 0)
/*         AND d.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl