/* Formatted on 25.02.2013 10:00:41 (QP5 v5.163.1008.3004) */
SELECT COUNT (DISTINCT an.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.summa) summa,

         SUM (d.sskuw) sskuw,
         SUM (d.qskuw) qskuw,

       SUM (an.ok_chief) ok_chief,
       SUM (an.bonus_sum) bonus_sum,
       AVG ( (SELECT SUM (bonus) bonus
                FROM a13_pk_files f, user_list st
               WHERE     f.ok_traid = 1
                     AND f.tn = st.tn
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                     AND (st.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :tn)
                          OR (SELECT NVL (is_traid, 0)
                                FROM user_list
                               WHERE tn = :tn) = 1)
                     AND st.dpt_id = :dpt_id))
          files_bonus,
       DECODE (NVL (SUM (d.summa), 0), 0, 0, (SUM (an.bonus_sum)) / SUM (d.summa)) * 100 zat
  FROM a13_pk d,
       a13_pk_action_nakl an,
       user_list st,
       a13_pk_tp_select tp
 WHERE     d.tab_num = st.tab_num
       AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
       AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
       AND (st.tn IN (SELECT slave
                        FROM full
                       WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id
       AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
       AND d.tp_kod = tp.tp_kod
       AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
       AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief,  1, 0,  2, an.ok_chief,  3, NVL (an.ok_chief, 0))
       AND decode(nvl(an.if1,0),0,0,1) = 1
