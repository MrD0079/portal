/* Formatted on 12.08.2018 12:56:26 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tn key,
         wm_concat (DISTINCT region_name) region_name,
         sum(cto) cto,
         /*SUM (ts1) ts1,*/
         SUM (ts1r) ts1r/*,
         SUM (auditor1) auditor1,
         DECODE (NVL (COUNT (DISTINCT tp_kod_key || visitdate), 0),
                 0, 0,
                 SUM (ts1) / COUNT (DISTINCT tp_kod_key || visitdate) * 100)
            perc_ts,
         DECODE (
            NVL (SUM (CASE WHEN ts1 = 1 AND auditornull = 0 THEN 1 END), 0),
            0, 0,
              NVL (SUM (CASE WHEN ts1 = 1 AND auditor1 = 1 THEN 1 END), 0)
            / NVL (SUM (CASE WHEN ts1 = 1 AND auditornull = 0 THEN 1 END), 0)
            * 100)
            perc_auditor,
         SUM (tsnull) tsnull,
         SUM (auditornull) auditornull,
         SUM (reject_traid) reject_traid,
         SUM (reject_auditor) reject_auditor,
         SUM (reject_traid_or_auditor) reject_traid_or_auditor*/
    FROM (:brief)
GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn
ORDER BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn