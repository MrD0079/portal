/* Formatted on 25.11.2013 13:54:09 (QP5 v5.227.12220.39724) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.summa,
         d.boxqtyc1,
         d.boxqtyc2,
         d.boxqtysah,
         d.tp_addr,
         NVL (an.if1, 0) selected_if1,
         NVL (an.u_type, 0) u_type,
         an.bonus_type,
         an.bonus_sum1,
         an.bonus_sum1 * 8.9 bonus_sum,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         TO_CHAR (an.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
         TO_CHAR (an.ok_traid_date, 'dd.mm.yyyy hh24:mi:ss') ok_traid_date,
         an.ok_chief,
         an.ok_traid,
         an.ok_traid_fio,
         NVL (an.ok_chief_fio,
              fn_getname (
                           (SELECT parent
                              FROM parents
                             WHERE tn = st.tn)))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn,
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
         0 max_kart1,
         NVL (
            CASE
               WHEN (boxqtyc1 >= 7 AND boxqtyc2 >= 3)
               THEN
                  LEAST (TRUNC (boxqtyc1 / 7), TRUNC (boxqtyc2 / 3))
            END,
            0)
            max_kart2,
         0 max_kart3,
         NVL ( (CASE WHEN boxqtyc1 >= 7 THEN TRUNC (boxqtyc1 / 7) END) * 142,
              0)
            max_prod1,
         NVL (
              (CASE
                  WHEN (boxqtyc1 >= 7 AND boxqtyc2 >= 3)
                  THEN
                     LEAST (TRUNC (boxqtyc1 / 7), TRUNC (boxqtyc2 / 3))
               END)
            * 120,
            0)
            max_prod2,
         NVL (
              (CASE WHEN boxqtysah >= 200 THEN TRUNC (boxqtysah / 200) END)
            * 20.5,
            0)
            max_prod3
    FROM a13_nh d,
         a13_nh_action_nakl an,
         user_list st,
         a13_nh_tp_select tp
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts,
                                     0, DECODE (:tn,
                                                -1, (SELECT MAX (tn)
                                                       FROM user_list
                                                      WHERE is_admin = 1),
                                                :tn),
                                     :exp_list_without_ts))
         AND st.tn IN
                (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts,
                                     0, DECODE (:tn,
                                                -1, (SELECT MAX (tn)
                                                       FROM user_list
                                                      WHERE is_admin = 1),
                                                :tn),
                                     :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn,
                                                   -1, (SELECT MAX (tn)
                                                          FROM user_list
                                                         WHERE is_admin = 1),
                                                   :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = DECODE (:tn,
                                      -1, (SELECT MAX (tn)
                                             FROM user_list
                                            WHERE is_admin = 1),
                                      :tn)) = 1)
         AND st.dpt_id = :dpt_id
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_chief,
                        1, 0,
                        2, an.ok_chief,
                        3, NVL (an.ok_chief, 0))
         --         AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.data, 'mm')))
         AND DECODE (NVL (an.if1, 0), 0, 0, 1) = 1
/*         AND d.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl