/* Formatted on 28.09.2012 16:31:38 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (c.data, 'dd') dm,
         TO_CHAR (c.data, 'dd.mm.yyyy') dt,
         TO_CHAR (c.data, 'ddmmyyyy') dtt,
         c.data,
         c.is_wd,
         c.dwt,
         mz_rep_m.lu,
         TO_CHAR (mz_rep_d_ras.lu, 'dd.mm.yyyy hh24:mi:ss') mz_rep_d_lu,
         mz_rep_d_ras.text,
         mz_rep_d_ras.mz_admin_ok,
         mz_rep_d_ras.mz_admin_ok_tn,
         fn_getname (mz_rep_d_ras.mz_admin_ok_tn) mz_admin_ok_name,
         mz_rep_d_spr_ras.val,
         mz_rep_d_spr_ras.spr_id,
         c.id,
         c.name,
         mz_rep_f_ras.fn
    FROM (SELECT *
            FROM calendar, mz_spr_ras) c,
         (SELECT *
            FROM mz_rep_m
           WHERE mz_id = :mz_id) mz_rep_m,
         (SELECT *
            FROM mz_rep_d_ras
           WHERE mz_id = :mz_id) mz_rep_d_ras,
         (SELECT *
            FROM mz_rep_d_spr_ras
           WHERE mz_id = :mz_id) mz_rep_d_spr_ras,
         (SELECT *
            FROM mz_rep_f_ras
           WHERE mz_id = :mz_id) mz_rep_f_ras
   WHERE     TRUNC (c.data, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')
         AND TRUNC (c.data, 'mm') = mz_rep_m.dt(+)
         AND c.data = mz_rep_d_ras.dt(+)
         AND c.data = mz_rep_d_spr_ras.dt(+)
         AND c.data = mz_rep_f_ras.dt(+)
         AND c.id = mz_rep_d_spr_ras.spr_id(+)
ORDER BY c.data, c.name