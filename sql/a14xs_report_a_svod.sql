/* Formatted on 21.01.2015 22:42:41 (QP5 v5.227.12220.39724) */
INSERT INTO act_svod (act,
                      m,
                      sales,
                      bonus,
                      tp,
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
            COUNT (DISTINCT tp_kod) tp,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn,
            :dpt_id

       FROM (SELECT :act act,
                    :month m,
                    d.summnds sales,
                    an.bonus_sum1 bonus,
                    d.tp_kod,
                    fn_getname (
                                 (SELECT parent
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
               FROM a14xs d,
                    a14xs_action_nakl an,
                    user_list st,
                    a14xs_tp_select tp
              WHERE     d.tab_num = st.tab_num
                    AND st.dpt_id = :dpt_id
                    AND d.h_tp_kod_data_nakl = an.h_tp_kod_data_nakl(+)
                    AND d.tp_kod = tp.tp_kod
                    AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) =
                           d.h_fio_eta
                    AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = :month
                    AND tp.m = :month
                    AND st.tn IN
                           (SELECT slave
                              FROM full
                             WHERE master =
                                      DECODE (:exp_list_without_ts,
                                              0, master,
                                              :exp_list_without_ts))
                    AND st.tn IN
                           (SELECT slave
                              FROM full
                             WHERE master =
                                      DECODE (:exp_list_only_ts,
                                              0, master,
                                              :exp_list_only_ts))
                    AND (   st.tn IN
                               (SELECT slave
                                  FROM full
                                 WHERE master = DECODE (:tn, -1, master, :tn))
                         OR (SELECT NVL (is_traid, 0)
                               FROM user_list
                              WHERE tn = :tn) = 1)
                    AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                           DECODE (:ok_bonus,
                                   1, 0,
                                   2, DECODE (an.bonus_dt1, NULL, 0, 1),
                                   3, DECODE (an.bonus_dt1, NULL, 0, 1))
                    AND CASE
                           WHEN     NVL (d.truf, 0) > 0
                                AND NVL (d.sharm, 0) > 0
                                AND NVL (d.temn, 0) > 0
                                AND NVL (d.other, 0) > 0
                           THEN
                              1
                           ELSE
                              0
                        END = 1)
   GROUP BY act,
            m,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn