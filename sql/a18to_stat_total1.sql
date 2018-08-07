/* Formatted on 1/15/2016 12:32:18  (QP5 v5.252.13127.32867) */
SELECT count(distinct name_to) cto,
       SUM (ts1) ts1,
         SUM (ts1r) ts1r,
       SUM (auditor1) auditor1,
       DECODE (NVL (COUNT (DISTINCT tp_kod_key || visitdate), 0),
               0, 0,
               SUM (ts1) / COUNT (DISTINCT tp_kod_key || visitdate) * 100)
          perc_ts,
       DECODE (
          /*COUNT (DISTINCT tp_kod_key || visitdate)*/
          NVL (SUM (CASE WHEN ts1 = 1 AND auditornull = 0 THEN 1/*urls*/ END), 0),
          0, 0,
            NVL (SUM (CASE WHEN ts1 = 1 AND auditor1 = 1 THEN 1 END), 0)
          /                       /*COUNT (DISTINCT tp_kod_key || visitdate)*/
           NVL (SUM (CASE WHEN ts1 = 1 AND auditornull = 0 THEN 1/*urls*/ END),
                0)
          * 100)
          perc_auditor,
       SUM (tsnull) tsnull,
       SUM (auditornull) auditornull,
         SUM (reject_traid) reject_traid,
         SUM (reject_auditor) reject_auditor,
         SUM (reject_traid_or_auditor) reject_traid_or_auditor
  FROM (SELECT z.*,
                 CASE
                    WHEN :by_who = 'eta' THEN type_standart_price_eta
                    WHEN :by_who = 'ts' THEN type_standart_price_ts
                 END
                    type_standart_price
            FROM a18to_mv z
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
                 AND (:eta_list is null OR :eta_list = h_fio_eta)
                 AND DECODE ( :ok_ts, 1, ok_ts, :ok_ts) = ok_ts
                 AND DECODE ( :ok_auditor, 1, ok_auditor, :ok_auditor) = ok_auditor
                 AND DECODE ( :st_ts, 1, st_ts, :st_ts) = st_ts
                 AND DECODE ( :st_auditor, 1, st_auditor, :st_auditor) = st_auditor
                 AND DECODE ( :ok_st_tm, 1, ok_st_tm, :ok_st_tm) = ok_st_tm
                       AND (   :type_standart = 1
                            OR ( :type_standart = 2 AND type_standart = 'A')
                            OR ( :type_standart = 3 AND type_standart = 'B'))
                 AND (   :zst = 1
                      OR ( :zst = 2 AND DECODE (zst_lu, NULL, 0, 1) = 1)))