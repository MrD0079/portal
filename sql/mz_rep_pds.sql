/* Formatted on 11.10.2012 14:08:02 (QP5 v5.163.1008.3004) */
SELECT TO_CHAR (pds.dt, 'dd.mm.yyyy') dt,
       TO_CHAR (pds.pds_dt, 'dd.mm.yyyy') pds_dt,
       TO_CHAR (c.data, 'ddmmyyyy') pds_dtt,
       pds.pds_sum,
       TO_CHAR (pds.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
       pds.text,
       pds.mz_admin_ok,
       pds.mz_admin_ok_tn,
       fn_getname ( pds.mz_admin_ok_tn) mz_admin_ok_name,
       pds.id
  FROM mz_rep_m_pds pds
 WHERE pds.mz_id = :mz_id
       AND TRUNC (pds.dt, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')
order by pds.pds_dt