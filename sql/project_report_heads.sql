/* Formatted on 02.11.2012 13:56:46 (QP5 v5.163.1008.3004) */
SELECT *
  FROM project p
 WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
       AND parent = 0
       AND dpt_id = :dpt_id
       AND ( (SELECT SUM (fn_get_prj_grant (p.id, slave, 1))
                FROM full
               WHERE master = :tn and full in (0,1)) <> 0
            OR fn_get_prj_grant (p.id, :tn, 1) = 2)