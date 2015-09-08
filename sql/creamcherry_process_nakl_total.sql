/* Formatted on 22.02.2013 15:47:41 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c1,
         SUM (d.summa) summa,
         SUM (d.SUMNDS_CREAM_CHER) SUMNDS_CREAM_CHER,
         SUM (d.SUMMNDS_FK) SUMMNDS_FK,
         SUM (d.QTYSKUFK) QTYSKUFK,
         SUM (d.CREAM_CHERRY_QTY) CREAM_CHERRY_QTY,
         SUM (an.bonus_sum) bonus_sum
    FROM creamcherry d, creamcherry_action_nakl an, user_list st
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
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl