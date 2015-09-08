/* Formatted on 25.09.2013 11:38:21 (QP5 v5.227.12220.39724) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         d.summa,
         d.cond1,
         d.cond2,
         d.cond3,
         d.sumveskonf,
         CASE
            WHEN d.cond1 = 1 OR (d.sumveskonf >= 1400 AND d.sumveskonf < 1800)
            THEN
               1
            ELSE
               0
         END
            c1,
         CASE
            WHEN d.cond2 = 1 OR (d.sumveskonf >= 1800 AND d.sumveskonf < 2300)
            THEN
               1
            ELSE
               0
         END
            c2,
         CASE WHEN d.cond3 = 1 OR (d.sumveskonf >= 2300) THEN 1 ELSE 0 END c3,
         CASE
            WHEN d.cond3 = 1 OR (d.sumveskonf >= 2300)
            THEN
               3
            WHEN d.cond2 = 1 OR (d.sumveskonf >= 1800 AND d.sumveskonf < 2300)
            THEN
               2
            WHEN d.cond1 = 1 OR (d.sumveskonf >= 1400 AND d.sumveskonf < 1800)
            THEN
               1
            ELSE
               0
         END
            c,
         CASE
            WHEN    d.cond1 = 1
                 OR d.cond2 = 1
                 OR d.cond3 = 1
                 OR d.sumveskonf >= 1400
            THEN
               1
            ELSE
               0
         END
            if1,
         NVL (an.if1, 0) selected_if1,
         an.ok_traid,
         an.ok_chief,
         an.bonus_sum1,
         d.H_TP_KOD_DATA_NAKL,
         GREATEST (
            CASE
               WHEN cond1 = 1 OR (sumveskonf >= 1400 AND sumveskonf < 1800)
               THEN
                  100
               ELSE
                  0
            END,
            CASE
               WHEN cond2 = 1 OR (sumveskonf >= 1800 AND sumveskonf < 2300)
               THEN
                  200
               ELSE
                  0
            END,
            CASE WHEN cond3 = 1 OR (sumveskonf >= 2300) THEN 400 ELSE 0 END)
            max_ya
    FROM a13_sv9 d, a13_sv9_action_nakl an, user_list st
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
         AND DECODE (:tp, 0, DECODE (NVL (an.if1, 0), 0, 0, 1), 0) =
                DECODE (:tp, 0, 1, 0)
/*         AND d.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl