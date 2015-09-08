/* Formatted on 20.07.2012 12:48:31 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       SUM (d.summa) summa,
       SUM (d.summnds_pg) summnds_pg,
       SUM (d.qtysku) qtysku,
       SUM (an.bonus) bonus,
       COUNT (DISTINCT d.tp_kod) tp_kod,
       SUM (NVL (ok_traid, 0)) ok_traid,
       DECODE (SUM (d.summnds_pg), 0, 0, SUM (an.bonus) / SUM (d.summnds_pg) * 100) zat_perc
  FROM hot_aug d, hot_aug_action_nakl an, user_list st
 WHERE     d.tab_num = st.tab_num
                 AND st.tn IN
                        (SELECT slave
                                 FROM full
                                WHERE master =
                                   DECODE (:exp_list_without_ts,
                                           0, :tn,
                                           :exp_list_without_ts))
                 AND st.tn IN
                        (SELECT slave
                                 FROM full
                                WHERE master =
                                   DECODE (:exp_list_only_ts,
                                           0, :tn,
                                           :exp_list_only_ts))
       AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
       AND st.dpt_id = :dpt_id
       /*       AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
              AND DECODE (:tp, 0, d.nakl, 0) = DECODE (:tp, 0, an.nakl, 0)*/
       AND d.tp_kod = an.tp_kod                                        /*(+)*/
       AND d.nakl = an.nakl                                            /*(+)*/
       AND d.data BETWEEN TO_DATE ('01.08.2012', 'dd.mm.yyyy')
                      AND TO_DATE ('31.08.2012', 'dd.mm.yyyy')
       AND DECODE (:ok_traid,  1, 0,  2, 1,  3, 0) =
              DECODE (:ok_traid,
                      1, 0,
                      2, an.ok_traid,
                      3, NVL (an.ok_traid, 0))



         AND DECODE (:eta_list, '', d.fio_eta, :eta_list) = d.fio_eta
