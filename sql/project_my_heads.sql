/* Formatted on 25.10.2012 16:37:10 (QP5 v5.163.1008.3004) */
SELECT *
  FROM project
 WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
       AND parent = 0
       AND dpt_id = :dpt_id
       AND fn_get_prj_grant (id, :tn) = 1