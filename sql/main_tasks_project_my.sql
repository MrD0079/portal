/* Formatted on 28.12.2012 9:51:08 (QP5 v5.163.1008.3004) */
/*SELECT count(*)
  FROM project
 WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
       AND parent = 0
       AND dpt_id = :dpt_id
       AND fn_get_prj_grant (id, :tn) = 1*/

SELECT COUNT (DISTINCT (SELECT parent
                          FROM project
                         WHERE id = z1.parent))
  FROM (    SELECT DECODE (completed_dt, NULL, 0, DECODE (SIGN (dt_end - TRUNC (completed_dt)), -1, 0, 1)) vsrok,
                   DECODE (completed_dt, NULL, 0, DECODE (SIGN (dt_end - TRUNC (completed_dt)), -1, 1, 0)) prosroch,
                   LEVEL,
                   z.id,
                   z.parent,
                   z.name,
                   z.lu,
                   z.sort,
                   TO_CHAR (z.dt_start, 'dd/mm/yyyy') dt_start,
                   TO_CHAR (z.dt_end, 'dd/mm/yyyy') dt_end,
                   TO_CHAR (z.dt_fin, 'dd/mm/yyyy') dt_fin,
                   TO_CHAR (r.completed_dt, 'dd/mm/yyyy hh24:mi:ss') completed_dt,
                   TO_CHAR (r.ok_chief_dt, 'dd/mm/yyyy hh24:mi:ss') ok_chief_dt,
                   r.completed_tn,
                   r.ok_chief_tn,
                   r.text,
                   fn_getname ( r.completed_tn) completed_fio,
                   fn_getname ( r.ok_chief_tn) ok_chief_fio
              FROM project z,
                   (SELECT *
                      FROM project_report
                     WHERE tn = :tn) r
             WHERE z.id = r.prj_node_id(+) AND LEVEL = 2 AND fn_get_prj_node_grant (z.id, :tn, LEVEL) = 1
        START WITH z.PARENT IN (SELECT id
                                  FROM project
                                 WHERE TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id) AND parent = 0 AND dpt_id = :dpt_id AND fn_get_prj_grant (id, :tn) = 1)
        CONNECT BY PRIOR z.ID = z.PARENT) z1
 WHERE completed_dt IS NULL