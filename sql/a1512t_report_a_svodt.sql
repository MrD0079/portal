/* Formatted on 12/22/2015 12:54:03  (QP5 v5.252.13127.32867) */
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
                    d.act_summ sales,
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
               FROM A1512T_XLS_SALESPLAN sp,
                    A1512T_XLS_TPCLIENT tp,
                    a1512t d,
                    A1512t_ACTION_CLIENT an,
                    user_list st
              WHERE     d.tab_num = st.tab_num
                    AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                    AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                    AND (   st.tn IN (SELECT slave
                                        FROM full
                                       WHERE master =
                                                DECODE ( :tn, -1, master, :tn))
                         OR (SELECT NVL (is_traid, 0)
                               FROM user_list
                              WHERE tn = :tn) = 1)
                    AND st.dpt_id = :dpt_id and st.is_spd=1
                    AND tp.tp_kod = d.tp_kod
                    AND sp.H_client = tp.H_client
                    AND sp.H_client = an.H_client(+)
                    AND DECODE ( :eta_list, '', d.h_fio_eta, :eta_list) =
                           d.h_fio_eta
                    AND DECODE ( :ok_bonus,  1, 0,  2, 1,  3, 0) =
                           DECODE ( :ok_bonus,
                                   1, 0,
                                   2, DECODE (an.bonus_dt1, NULL, 0, 1),
                                   3, DECODE (an.bonus_dt1, NULL, 0, 1)))
   GROUP BY act,
            m,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn