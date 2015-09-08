/* Formatted on 11.10.2012 9:01:56 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (c.data, 'dd') dm,
         TO_CHAR (c.data, 'dd.mm.yyyy') dt,
         TO_CHAR (c.data, 'ddmmyyyy') dtt,
         c.data,
         c.is_wd,
         c.dwt,
         mz_rep_m.lu,
         TO_CHAR (mz_rep_d_pri.lu, 'dd.mm.yyyy hh24:mi:ss') mz_rep_d_lu,
         mz_rep_d_pri.text,
         mz_rep_d_pri.mz_admin_ok,
         mz_rep_d_pri.mz_admin_ok_tn,
         fn_getname ( mz_rep_d_pri.mz_admin_ok_tn) mz_admin_ok_name,
         mz_rep_d_spr_pri.val,
         mz_rep_d_spr_pri.spr_id,
         c.id,
         c.name
    FROM (SELECT *
            FROM calendar, mz_spr_pri) c,
         (SELECT *
            FROM mz_rep_m
           WHERE mz_id = :mz_id) mz_rep_m,
         (SELECT *
            FROM mz_rep_d_pri
           WHERE mz_id = :mz_id) mz_rep_d_pri,
         (SELECT *
            FROM mz_rep_d_spr_pri
           WHERE mz_id = :mz_id) mz_rep_d_spr_pri
   WHERE     TRUNC (c.data, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')
         AND TRUNC (c.data, 'mm') = mz_rep_m.dt(+)
         AND c.data = mz_rep_d_pri.dt(+)
         AND c.data = mz_rep_d_spr_pri.dt(+)
         AND c.id = mz_rep_d_spr_pri.spr_id(+)
ORDER BY c.data, c.name