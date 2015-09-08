/* Formatted on 11.10.2012 9:01:56 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (c.data, 'dd') dm,
         TO_CHAR (c.data, 'dd.mm.yyyy') dt,
         TO_CHAR (c.data, 'ddmmyyyy') dtt,
         c.data,
         c.is_wd,
         c.dwt,
         mz_rep_m.lu,
         mz_rep_m.invent,
         mz_rep_m.nsv,
         mz_rep_m.ld_ost,
         mz_rep_m.ppr,
         mz_rep_m.ppd,
         c.id,
         c.name
    FROM (SELECT *
            FROM calendar, mz_spr_pri) c,
         (SELECT *
            FROM mz_rep_m
           WHERE mz_id = :mz_id) mz_rep_m
   WHERE     TRUNC (c.data, 'mm') = TO_DATE (:month_list, 'dd/mm/yyyy')
         AND TRUNC (c.data, 'mm') = mz_rep_m.dt(+)
ORDER BY c.data, c.name