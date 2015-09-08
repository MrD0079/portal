/* Formatted on 26/03/2015 16:53:08 (QP5 v5.227.12220.39724) */
  SELECT lpr.*,
         st.fio ts_fio,
                  (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

            ok_chief,
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
                  (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

            ok_chief_date
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
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', lpr.h_fio_eta, :eta_list) = lpr.h_fio_eta
ORDER BY parent_fio, ts_fio, lpr.fio_eta