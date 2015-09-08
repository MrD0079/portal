/* Formatted on 05/08/2014 13:57:55 (QP5 v5.227.12220.39724) */
  SELECT ROWNUM,
         e.*,
         fn_getname (e.emp_tn) emp_name,
         fn_getname (e.exp_tn) exp_name,
         emp_tn emp_svid,
         exp_tn exp_svid,
         d_m.dpt_name dpt_name_m,
         d_x.dpt_name dpt_name_x,
         TO_CHAR (st_m.datauvol, 'dd.mm.yyyy') emp_datauvol,
         TO_CHAR (st_x.datauvol, 'dd.mm.yyyy') exp_datauvol
    FROM emp_exp e,
         spdtree st_m,
         spdtree st_x,
         departments d_m,
         departments d_x
   WHERE     st_m.svideninn = e.emp_tn
         AND st_x.svideninn = e.exp_tn
         AND st_m.dpt_id = D_m.DPT_ID
         AND st_x.dpt_id = D_x.DPT_ID
         AND (st_m.dpt_id = :dpt_id OR st_x.dpt_id = :dpt_id)
         AND (   DECODE (:flt,
                         0, SYSDATE,
                         1, NVL (st_m.datauvol, SYSDATE),
                         -1, st_m.datauvol) =
                    DECODE (:flt,  0, SYSDATE,  1, SYSDATE,  -1, st_m.datauvol)
              /*OR DECODE (:flt,
                         0, SYSDATE,
                         1, NVL (st_x.datauvol, SYSDATE),
                         -1, st_x.datauvol) =
                    DECODE (:flt,  0, SYSDATE,  1, SYSDATE,  -1, st_x.datauvol)*/)
ORDER BY emp_name, exp_name