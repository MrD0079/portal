/* Formatted on 11.01.2013 13:21:04 (QP5 v5.163.1008.3004) */
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
         an.tn_ts
    FROM (SELECT DISTINCT tab_num,
                          fio_ts,
                          fio_eta,
                          tp_ur,
                          tp_addr,
                          tp_kod
            FROM val_mart) d,
         ko_action_nakl an,
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