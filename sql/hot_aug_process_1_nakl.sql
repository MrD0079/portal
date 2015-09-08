/* Formatted on 18.07.2012 14:34:46 (QP5 v5.163.1008.3004) */
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
         CASE WHEN d.summnds_pg >= 590 AND d.qtysku >= 6 and nvl((select sum(summnds_pg) from hot_aug where tp_kod=d.tp_kod and trunc(data,'mm')='01.07.2012'),0)<=500 THEN 1 END action_nakl,
         DECODE (an.nakl, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         an.bonus,
         an.text
    FROM hot_aug d, hot_aug_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.tn = :tn
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, d.nakl, 0) = DECODE (:tp, 0, an.nakl, 0)
         AND d.tp_kod = an.tp_kod(+)
         AND d.nakl = an.nakl(+)
         AND d.data BETWEEN TO_DATE ('01.08.2012', 'dd.mm.yyyy')
                        AND TO_DATE ('31.08.2012', 'dd.mm.yyyy')
         AND DECODE (:eta_list, '', d.fio_eta, :eta_list) = d.fio_eta
ORDER BY st.fio,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.data,
         d.nakl