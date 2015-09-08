/* Formatted on 13/08/2014 12:33:37 (QP5 v5.227.12220.39724) */
  SELECT u.fio,
         u.tn,
         u.pos_name,
         u.dpt_name,
         TO_CHAR (u.datauvol, 'dd.mm.yyyy') datauvol
    FROM user_list u,
         (SELECT *
            FROM emp_exp
           WHERE full = 1 AND emp_tn <> exp_tn) e
   WHERE     u.is_spd = 1
         AND u.tn = e.emp_tn(+)
         AND e.emp_tn IS NULL
         AND u.dpt_id = :dpt_id
         AND (DECODE (:flt,
                      0, SYSDATE,
                      1, NVL (u.datauvol, SYSDATE),
                      -1, u.datauvol) =
                 DECODE (:flt,  0, SYSDATE,  1, SYSDATE,  -1, u.datauvol))
ORDER BY u.fio