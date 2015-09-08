/* Formatted on 02/04/2015 14:14:06 (QP5 v5.227.12220.39724) */
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
                    /*lpr.sales*/
                    0 sales,
                    tps.bonus_sum1 bonus,
                    lpr.tp_kod,
                    fn_getname (
                                 (SELECT parent
                                    FROM parents
                                   WHERE tn = st.tn))
                       fio_db,
                    st.fio fio_ts,
                    st.tab_num ts_tab_num,
                    lpr.fio_eta,
                    lpr.h_fio_eta,
                    (SELECT parent
                       FROM parents
                      WHERE tn = st.tn)
                       db_tn
               FROM a1503plpr_tp_select tps, user_list st, a1503plpr lpr
              WHERE     lpr.tp_kod = tps.tp_kod
                    AND lpr.tab_num = st.tab_num
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
                    AND DECODE (:eta_list, '', lpr.h_fio_eta, :eta_list) =
                           lpr.h_fio_eta)
   GROUP BY act,
            m,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn