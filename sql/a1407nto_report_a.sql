/* Formatted on 21.01.2015 17:23:34 (QP5 v5.227.12220.39724) */
  SELECT tp.*,
         st.fio ts_fio,
         TO_CHAR (tps.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         tps.bonus_sum1,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         tps.ok_chief_ln,
         tps.ok_chief_ln_fio,
         TO_CHAR (tps.ok_chief_ln_lu, 'dd.mm.yyyy hh24:mi:ss') ok_chief_ln_lu
    FROM (SELECT DISTINCT tp_kod,
                          tab_number,
                          eta,
                          h_eta,
                          tp_name,
                          address,
                          d.dpt_id
            FROM routes r, departments d
           WHERE d.manufak = r.country AND d.dpt_id = :dpt_id) tp,
         a1407nto_tp_select tps,
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
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', tp.h_eta, :eta_list) = tp.h_eta
         AND tp.tp_kod = tps.tp_kod
ORDER BY parent_fio, ts_fio, tp.eta