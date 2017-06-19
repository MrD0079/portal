/* Formatted on 28/05/2015 16:54:11 (QP5 v5.227.12220.39724) */
INSERT INTO act_svodt (act,
                       m,
                       sales,
                       bonus,
                       tp_kod,
                       fio_db,
                       fio_ts,
                       ts_tab_num,
                       fio_eta,
                       h_fio_eta,
                       db_tn,
                       dpt_id)
     SELECT act,
            m,
            SUM (sales) sales,
            SUM (bonus) bonus,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn,
            :dpt_id
       FROM (SELECT :act act,
                    :month m,
                    d.nakl_summ sales,
                    an.bonus_sum1 bonus,
                    d.tp_kod,
                    fn_getname ( (SELECT parent
                                    FROM parents
                                   WHERE tn = st.tn))
                       fio_db,
                    st.fio fio_ts,
                    st.tab_num ts_tab_num,
                    d.fio_eta,
                    d.h_fio_eta,
                    (SELECT parent
                       FROM parents
                      WHERE tn = st.tn)
                       db_tn
               FROM a15return d, a15return_action_nakl an, user_list st
              WHERE     d.tab_num = st.tab_num
                    AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                    AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                    AND (   st.tn IN
                               (SELECT slave
                                  FROM full
                                 WHERE master = DECODE (:tn, -1, master, :tn))
                         OR (SELECT NVL (is_traid, 0)
                               FROM user_list
                              WHERE tn = :tn) = 1)
                    AND st.dpt_id = :dpt_id and st.is_spd=1
                    AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                    AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) =
                           d.h_fio_eta
                    AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                           DECODE (:ok_bonus,
                                   1, 0,
                                   2, DECODE (an.bonus_dt1, NULL, 0, 1),
                                   3, DECODE (an.bonus_dt1, NULL, 0, 1))
                    AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = :month)
   GROUP BY act,
            m,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn