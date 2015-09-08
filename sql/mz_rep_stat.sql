/* Formatted on 05.04.2013 13:21:53 (QP5 v5.163.1008.3004) */
  SELECT mz.name,
         NVL ( (SELECT SUM (val)
                  FROM mz_rep_d_spr_inv
                 WHERE TRUNC (dt, 'mm') = TRUNC (TO_DATE (:month_list, 'dd/mm/yyyy'), 'mm') AND dt <> TRUNC (SYSDATE) AND mz_id = mz.id),
              0)
            inv_m,
         NVL ( (SELECT SUM (val)
                  FROM mz_rep_d_spr_pri
                 WHERE TRUNC (dt, 'mm') = TRUNC (TO_DATE (:month_list, 'dd/mm/yyyy'), 'mm') AND dt <> TRUNC (SYSDATE) AND mz_id = mz.id),
              0)
            pri_m,
         NVL ( (SELECT SUM (val)
                  FROM mz_rep_d_spr_ras
                 WHERE TRUNC (dt, 'mm') = TRUNC (TO_DATE (:month_list, 'dd/mm/yyyy'), 'mm') AND dt <> TRUNC (SYSDATE) AND mz_id = mz.id),
              0)
            ras_m,
         NVL ( (SELECT SUM (val)
                  FROM mz_rep_d_spr_rss
                 WHERE TRUNC (dt, 'mm') = TRUNC (TO_DATE (:month_list, 'dd/mm/yyyy'), 'mm') AND dt <> TRUNC (SYSDATE) AND mz_id = mz.id),
              0)
            rss_m,
         NVL ( (SELECT SUM (val)
                  FROM mz_rep_d_spr_vis
                 WHERE TRUNC (dt, 'mm') = TRUNC (TO_DATE (:month_list, 'dd/mm/yyyy'), 'mm') AND dt <> TRUNC (SYSDATE) AND mz_id = mz.id),
              0)
            vis_m,
         NVL ( (SELECT SUM (pds_sum)
                  FROM mz_rep_m_pds
                 WHERE TRUNC (dt, 'mm') = TRUNC (TO_DATE (:month_list, 'dd/mm/yyyy'), 'mm') AND dt <> TRUNC (SYSDATE) AND mz_id = mz.id),
              0)
            pds_m
    FROM mz_spr_mz mz
   WHERE DECODE (mz.dataz, NULL, 0, 1) = DECODE (:arc, 0, 0, 1) AND mz.id = :mz_id
ORDER BY mz.name