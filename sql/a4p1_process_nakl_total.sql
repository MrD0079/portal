/* Formatted on 18.07.2012 14:36:06 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       SUM (d.summa) summa,
       SUM (d.summnds_pg) summnds_pg,
       SUM (d.action_qt_ya) action_qt_ya,
       SUM (an.bonus) bonus,
       SUM (an.ya) fakt_ya
    FROM a4p1 d, a4p1_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.tn = :tn
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, 0, sign(to_date('15.09.2012','dd/mm/yyyy')-d.data)) = DECODE (:tp, 0, 0,1)
         AND DECODE (:tp, 0, d.nakl, 0) = DECODE (:tp, 0, an.nakl, 0)
         AND d.tp_kod = an.tp_kod(+)
         AND d.nakl = an.nakl(+)
         --AND TRUNC (d.data, 'mm') = '01.09.2012'
         AND DECODE (:eta_list, '', d.fio_eta, :eta_list) = d.fio_eta
