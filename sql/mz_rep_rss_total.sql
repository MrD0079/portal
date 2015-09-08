/* Formatted on 11.10.2012 16:46:01 (QP5 v5.163.1008.3004) */
  SELECT SUM (mz_rep_d_spr_rss.val) val, c.name
    FROM (SELECT *
            FROM calendar, mz_spr_ras) c,
         (SELECT *
            FROM mz_rep_d_spr_rss
           WHERE mz_id = :mz_id) mz_rep_d_spr_rss
   WHERE     TRUNC (c.data, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')
         AND c.data = mz_rep_d_spr_rss.dt(+)
         AND c.id = mz_rep_d_spr_rss.spr_id(+)
GROUP BY c.name
ORDER BY c.name