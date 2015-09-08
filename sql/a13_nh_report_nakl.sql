/* Formatted on 22.11.2013 16:39:38 (QP5 v5.227.12220.39724) */
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
         d.boxqtyc1,
         d.boxqtyc2,
         d.boxqtysah,
         CASE
            WHEN    boxqtyc1 >= 7
                 OR (boxqtyc1 >= 7 AND boxqtyc2 >= 3)
                 OR boxqtysah >= 200
            THEN
               1
            ELSE
               0
         END
            if1,
         NVL (an.if1, 0) selected_if1,
         CASE WHEN boxqtyc1 >= 7 THEN 1 END u1,
         CASE WHEN (boxqtyc1 >= 7 AND boxqtyc2 >= 3) THEN 1 END u2,
         CASE WHEN boxqtysah >= 200 THEN 1 END u3,
         CASE WHEN boxqtyc1 >= 7 THEN TRUNC (boxqtyc1 / 7) END count1,
         CASE
            WHEN (boxqtyc1 >= 7 AND boxqtyc2 >= 3)
            THEN
               LEAST (TRUNC (boxqtyc1 / 7), TRUNC (boxqtyc2 / 3))
         END
            count2,
         CASE WHEN boxqtysah >= 200 THEN TRUNC (boxqtysah / 200) END count3,
         an.ok_traid,
         an.ok_chief,
         an.bonus_sum1,
         d.H_TP_KOD_DATA_NAKL,
         LEAST (boxqtyc1, boxqtyc2, boxqtysah) max_ya
    FROM a13_nh d, a13_nh_action_nakl an, user_list st
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