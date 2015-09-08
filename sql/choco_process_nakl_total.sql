/* Formatted on 04.02.2013 14:08:36 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       SUM (d.summa) summa,
       SUM (d.summnds_pg) summnds_pg,
       sum(d.qtysku) qtysku,
sum(an.bonus_d_qty) bonus_d_qty,
sum(an.bonus_t_qty) bonus_t_qty






  FROM choco_box d, choco_action_nakl an, user_list st
 WHERE     d.tab_num = st.tab_num
/*       AND st.tn IN (SELECT slave
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