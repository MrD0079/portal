/* Formatted on 25/07/2014 16:44:37 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT tp_kod) cnt,
       SUM (DECODE (bonus_dt1, NULL, NULL, 1)) bonus_dt1,
       SUM (DECODE (bonus_dt1, NULL, NULL, bonus_sum1)) bonus_sum1
  FROM (  SELECT tp.*,
                 st.fio ts_fio,
                 (SELECT DECODE (lu, NULL, 0, 1)
                    FROM ACT_OK
                   WHERE tn = (SELECT parent
                                 FROM parents
                                WHERE tn = st.tn))
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
                   WHERE tn = (SELECT parent
                                 FROM parents
                                WHERE tn = st.tn))
                    ok_chief_date
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
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
                 AND st.dpt_id = :dpt_id
                 AND DECODE (:eta_list, '', tp.h_eta, :eta_list) = tp.h_eta
                 AND tp.tp_kod = tps.tp_kod
        ORDER BY parent_fio, ts_fio, tp.eta)