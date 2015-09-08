/* Formatted on 11.10.2012 16:46:01 (QP5 v5.163.1008.3004) */
  SELECT SUM (mz_rep_d_spr_ras.val) val, c.name
    FROM (SELECT *
            FROM calendar, mz_spr_ras) c,
         (SELECT *
            FROM mz_rep_d_spr_ras
           WHERE mz_id = :mz_id) mz_rep_d_spr_ras
   WHERE     TRUNC (c.data, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')
         AND c.data = mz_rep_d_spr_ras.dt(+)
         AND c.id = mz_rep_d_spr_ras.spr_id(+)
GROUP BY c.name
ORDER BY c.name