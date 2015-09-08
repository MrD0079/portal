/* Formatted on 04.06.2013 9:24:51 (QP5 v5.227.12220.39724) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt, 'dd.mm.yyyy') bonus_dt,
         d.summa,
         d.SummShokVes,
         d.SummPechVes,
         nvl(d.summa_aprel,0) sales_aprel,
         CASE
            WHEN     nvl(d.summa_aprel,0) >= 4501
                 AND nvl(d.summa_aprel,0) <= 15000
                 AND NVL (d.SummShokVes, 0) + NVL (d.SummPechVes, 0) >= 10000
                 AND NVL (d.SummPechVes, 0) >= 3000
                 AND NVL (d.SummShokVes, 0) >= 5000
            THEN
               4
            WHEN     nvl(d.summa_aprel,0) >= 4501
                 AND nvl(d.summa_aprel,0) <= 15000
                 AND NVL (d.SummShokVes, 0) + NVL (d.SummPechVes, 0) >= 5000
                 AND NVL (d.SummPechVes, 0) >= 1500
                 AND NVL (d.SummShokVes, 0) >= 2500
            THEN
               3
            WHEN     nvl(d.summa_aprel,0) >= 1601
                 AND nvl(d.summa_aprel,0) <= 4500
                 AND NVL (d.SummShokVes, 0) + NVL (d.SummPechVes, 0) >= 2000
                 AND NVL (d.SummPechVes, 0) >= 600
                 AND NVL (d.SummShokVes, 0) >= 1000
            THEN
               2
            WHEN     nvl(d.summa_aprel,0) >= 0
                 AND nvl(d.summa_aprel,0) <= 1600
                 AND NVL (d.SummShokVes, 0) + NVL (d.SummPechVes, 0) >= 1100
                 AND NVL (d.SummPechVes, 0) >= 330
                 AND NVL (d.SummShokVes, 0) >= 550
            THEN
               1
            ELSE
               0
         END
            is_act,
         DECODE (NVL (an.id, 0), 0, 0, 1) selected,
         an.ok_traid,
         an.ok_chief,
         an.bonus_sum,
         d.H_TP_KOD_DATA_NAKL
    FROM a13_mavk d, a13_mavk_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
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
--AND DECODE (:tp, 0, DECODE (NVL (an.if1, 0) + NVL (an.if2, 0), 0, 0, 1), 0) = DECODE (:tp, 0, 1, 0)
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl