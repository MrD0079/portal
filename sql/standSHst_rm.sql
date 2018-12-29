/* Formatted on 19.12.2016 12:51:06 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         tab_num_rm,
         tn_rm key,
         SUM (visit) visit,
         SUM (visit_st_ts) visit_st_ts,
         SUM (tp_st_ts) tp_st_ts,
         SUM (visit_st_ts_reject_tm_or_traid) visit_st_ts_reject_tm_or_traid,
         SUM (tp_st_ts_reject_tm_or_traid) tp_st_ts_reject_tm_or_traid,
         SUM (tp_st) tp_st,
         SUM (bonus) bonus
    FROM (SELECT FIO_RM,
         TN_RM,
         FIO_TM,
         TN_TM,
         TN,
         H_FIO_ETA,
         FIO_TS,
         FIO_ETA,
         TP_KOD_KEY,
         TP,
         TP_TYPE_SHORT,
         ETA_TAB_NUMBER,
         TAB_NUM_TS,
         TAB_NUM_TM,
         TAB_NUM_RM,
         DPT_ID,
         COUNT (DISTINCT visit) visit,
         COUNT (DISTINCT visit_st_ts) visit_st_ts,
         COUNT (DISTINCT tp_st_ts) tp_st_ts,
         COUNT (DISTINCT visit_st_ts_reject_tm_or_traid)
            visit_st_ts_reject_tm_or_traid,
         CASE
            WHEN     COUNT (DISTINCT visit_st_ts) =
                        COUNT (DISTINCT visit_st_ts_reject_tm_or_traid)
                 AND COUNT (DISTINCT visit_st_ts) > 0
            THEN
               1
            ELSE
               0
         END
            tp_st_ts_reject_tm_or_traid,
         COUNT (DISTINCT tp_st) tp_st,
         /*SUM (bonus)*/ bonus
    FROM (SELECT z.*,
                 CASE
                    WHEN :by_who = 'eta' THEN bonus_eta
                    WHEN :by_who = 'ts' THEN bonus_ts
                 END
                    bonus
            FROM standSH_mv z
           WHERE     visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND (   :exp_list_without_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                 AND (   tn IN (SELECT slave
                                  FROM full
                                 WHERE master IN (SELECT parent
                                                    FROM assist
                                                   WHERE     child = :tn
                                                         AND dpt_id = :dpt_id
                                                  UNION
                                                  SELECT DECODE ( :tn,
                                                                 -1, master,
                                                                 :tn)
                                                    FROM DUAL))
                      OR (SELECT NVL (is_admin, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid_kk, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_kpr, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND dpt_id = :dpt_id
                 AND ( :eta_list IS NULL OR :eta_list = h_fio_eta))
GROUP BY FIO_RM,
         TN_RM,
         FIO_TM,
         TN_TM,
         TN,
         H_FIO_ETA,
         FIO_TS,
         FIO_ETA,
         TP_KOD_KEY,
         TP,
         TP_TYPE_SHORT,
         ETA_TAB_NUMBER,
         TAB_NUM_TS,
         TAB_NUM_TM,
         TAB_NUM_RM,
         DPT_ID, bonus
ORDER BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         fio_eta,
         tp)
GROUP BY fio_rm, tn_rm, tab_num_rm
ORDER BY fio_rm, tn_rm