/* Formatted on 11.10.2012 16:49:10 (QP5 v5.163.1008.3004) */
  SELECT SUM (mz_rep_d_spr_inv.val) val, c.name
    FROM (SELECT *
            FROM calendar, mz_spr_inv) c,
         (SELECT *
            FROM mz_rep_d_spr_inv
           WHERE mz_id = :mz_id) mz_rep_d_spr_inv
   WHERE     TRUNC (c.data, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')
         AND c.data = mz_rep_d_spr_inv.dt(+)
         AND c.id = mz_rep_d_spr_inv.spr_id(+)
GROUP BY c.name
ORDER BY c.name