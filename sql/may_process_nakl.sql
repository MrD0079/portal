/* Formatted on 11.01.2013 13:24:54 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         an.summa,
         an.bonus,
         an.bonus_plan,
         TO_CHAR (an.DATA, 'dd.mm.yyyy') data,
         an.id,
         an.tn_ts,
         (SELECT name
            FROM may_types
           WHERE id = an.TYPE)
            TYPE,
         DECODE (NVL (an.summa, 0), 0, 0, an.bonus / an.summa * 100) perc
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