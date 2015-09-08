/* Formatted on 22.02.2013 15:47:41 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c1,
         SUM (d.summa) summa,
         SUM (d.CHER225Q) CHER225Q,
         SUM (d.CHER420Q) CHER420Q,
         SUM (an.bonus_sum1) bonus_sum1,
         SUM (an.bonus_sum2) bonus_sum2
    FROM a13_c11 d, a13_c11m_action_nakl an, user_list st
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
         AND DECODE (:tp, 0, decode(nvl(an.if1,0)+nvl(an.if2,0),0,0,1), 0) = DECODE (:tp, 0, 1, 0)
         AND d.data BETWEEN TO_DATE ('13.05.2013', 'dd.mm.yyyy') AND TO_DATE ('31.05.2013', 'dd.mm.yyyy')
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl