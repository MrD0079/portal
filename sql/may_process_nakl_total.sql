/* Formatted on 11.01.2013 13:25:07 (QP5 v5.163.1008.3004) */
  SELECT COUNT (DISTINCT d.tp_kod) tp_kod,
         SUM (an.ok_traid) ok_traid,
         SUM (an.ok_ts) ok_ts,
         SUM (an.ok_chief) ok_chief,
         SUM (an.summa) summa,
         SUM (an.bonus) bonus,
         SUM (an.bonus_plan) bonus_plan,
         DECODE (NVL (SUM (an.summa), 0), 0, 0, SUM (an.bonus) / SUM (an.summa) * 100) perc
    FROM (SELECT DISTINCT tab_number tab_num,
                          ts fio_ts,
                          eta fio_eta,
                          tp_name tp_ur,
                          address tp_addr,
                          tp_kod
            FROM may) d,
         may_action_nakl an,
         spdtree st
   WHERE     d.tab_num = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND d.tp_kod = an.tp_kod
         AND d.fio_eta = an.fio_eta
         AND st.dpt_id = :dpt_id
ORDER BY d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr