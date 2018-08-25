/* Formatted on 10.08.2018 21:51:53 (QP5 v5.252.13127.32867) */
SELECT SUM (cto) cto, /*SUM (ts1) ts1,*/
                      SUM (ts1r) ts1r /*,
                     SUM (auditor1) auditor1,
                     DECODE (NVL (COUNT (DISTINCT tp_kod_key || visitdate), 0),
                             0, 0,
                             SUM (ts1) / COUNT (DISTINCT tp_kod_key || visitdate) * 100)
                        perc_ts,
                     DECODE (

                        NVL (SUM (CASE WHEN ts1 = 1 AND auditornull = 0 THEN 1 END), 0),
                        0, 0,
                          NVL (SUM (CASE WHEN ts1 = 1 AND auditor1 = 1 THEN 1 END), 0)
                        /
                         NVL (SUM (CASE WHEN ts1 = 1 AND auditornull = 0 THEN 1 END),
                              0)
                        * 100)
                        perc_auditor,
                     SUM (tsnull) tsnull,
                     SUM (auditornull) auditornull,
                       SUM (reject_traid) reject_traid,
                       SUM (reject_auditor) reject_auditor,
                       SUM (reject_traid_or_auditor) reject_traid_or_auditor*/
                                     FROM (:brief)