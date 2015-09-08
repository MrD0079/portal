/* Formatted on 01.11.2012 9:03:06 (QP5 v5.163.1008.3004) */
SELECT *
  FROM project p
 WHERE TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
       AND parent = 0
       AND dpt_id = :dpt_id
       AND (SELECT SUM (fn_get_prj_grant (p.id, slave))
              FROM full
             WHERE /*dpt_id = :dpt_id AND */master = :tn AND full = 1) <> 0