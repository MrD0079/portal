/* Formatted on 01.07.2013 13:23:11 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c1,
         SUM (d.summa) summa,
         SUM (d.qty85) qty85,
         SUM (d.qty35) qty35,
         SUM (NVL (an.if1, 0)) if1,
         SUM (NVL (an.if2, 0)) if2
    FROM a13_tz d,
         a13_tz_action_nakl an,
         user_list st,
         A13_TZ_BONUS_CONDITIONS bc
   WHERE     d.tab_num = st.tab_num
         AND d.bonus = bc.id(+)
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
/*AND d.data BETWEEN TO_DATE ('13.05.2013', 'dd.mm.yyyy') AND TO_DATE ('31.05.2013', 'dd.mm.yyyy')*/
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl