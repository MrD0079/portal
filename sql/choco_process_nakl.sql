/* Formatted on 04.02.2013 14:07:31 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.summa,
         d.summnds_pg,
         d.qtysku,
         /*d.action_sum_ya,
         d.action_qt_ya,*/
         CASE WHEN d.qtysku>=5 AND d.summnds_pg>=100 THEN 1 ELSE 0 END action_nakl,
         DECODE (an.H_TP_KOD_DATA_NAKL, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         an.text,
         an.ya fakt_ya,
an.bonus_d_qty,
an.bonus_t_qty,
         d.H_TP_KOD_DATA_NAKL
    FROM choco_box d,
         choco_action_nakl an,
         user_list st
   WHERE     d.tab_num = st.tab_num
/*         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.tn = :tn
*/

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
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl