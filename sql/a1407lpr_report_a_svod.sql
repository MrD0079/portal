/* Formatted on 21.01.2015 22:04:20 (QP5 v5.227.12220.39724) */
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
                    NULL sales,
                    tps.bonus_sum1 bonus,
                    tp.tp_kod,
                    fn_getname (
                                 (SELECT parent
                                    FROM parents
                                   WHERE tn = st.tn))
                       fio_db,
                    st.fio fio_ts,
                    st.tab_num ts_tab_num,
                    tp.eta fio_eta,
                    tp.h_eta h_fio_eta,
                    (SELECT parent
                       FROM parents
                      WHERE tn = st.tn)
                       db_tn
               FROM (SELECT DISTINCT tp_kod,
                                     tab_number,
                                     eta,
                                     h_eta,
                                     tp_name,
                                     address,
                                     d.dpt_id
                       FROM routes r, departments d
                      WHERE d.manufak = r.country AND d.dpt_id = :dpt_id) tp,
                    a1407lpr_tp_select tps,
                    user_list st
              WHERE     tp.tab_number = st.tab_num
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
                    AND DECODE (:eta_list, '', tp.h_eta, :eta_list) = tp.h_eta
                    AND tp.tp_kod = tps.tp_kod)
   GROUP BY act,
            m,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn