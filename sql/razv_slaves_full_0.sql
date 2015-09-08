/* Formatted on 09/04/2015 13:13:48 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT z1.*
    FROM (SELECT DISTINCT fn_getname (e.emp_tn) emp_name,
                          e.emp_tn,
                          s.pos_name dolgn,
                          s.datauvol
            FROM emp_exp e, user_list s
           WHERE     e.exp_tn <> e.emp_tn
                 AND e.emp_tn = s.tn
                 AND s.dpt_id = :dpt_id
                 AND e.emp_tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :exp_tn AND full = 0)
                 AND NVL (s.is_top, 0) <> 1) z1
   WHERE ADD_MONTHS (TRUNC (NVL (datauvol, SYSDATE), 'mm'), +1) >=
            TRUNC (SYSDATE, 'mm')
ORDER BY emp_name