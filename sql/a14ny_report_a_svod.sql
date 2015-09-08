/* Formatted on 21.01.2015 22:11:03 (QP5 v5.227.12220.39724) */
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
                    d.summnakl sales,
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
               FROM a14ny d,
                    a14ny_action_nakl an,
                    user_list st,
                    a14ny_tp_select tp
              WHERE     d.tab_num = st.tab_num
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
                    AND st.dpt_id = :dpt_id
                    AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
                    AND d.tp_kod = tp.tp_kod
                    AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) =
                           d.h_fio_eta
                    AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = :month
                    AND tp.m = :month
                    AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                           DECODE (:ok_bonus,
                                   1, 0,
                                   2, DECODE (an.bonus_dt1, NULL, 0, 1),
                                   3, DECODE (an.bonus_dt1, NULL, 0, 1))
                    AND DECODE (:is_act,  1, 0,  2, 1,  3, 0) =
                           DECODE (
                              :is_act,
                              1, 0,
                              2, CASE WHEN d.summny >= 500 THEN 1 ELSE 0 END,
                              3, CASE WHEN d.summny >= 500 THEN 1 ELSE 0 END))
   GROUP BY act,
            m,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn