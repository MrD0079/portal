/* Formatted on 11.10.2012 16:53:51 (QP5 v5.163.1008.3004) */
SELECT SUM (pds.pds_sum)
  FROM mz_rep_m_pds pds
 WHERE pds.mz_id = :mz_id
       AND TRUNC (pds.dt, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')