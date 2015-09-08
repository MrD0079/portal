/* Formatted on 31.10.2012 16:59:54 (QP5 v5.163.1008.3004) */
           SELECT LEVEL,
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
            WHERE z.id = r.prj_node_id(+)
                  AND fn_get_prj_node_grant (z.id, :tn, LEVEL) = 1
       START WITH z.PARENT = :prj_id
       CONNECT BY PRIOR z.ID = z.PARENT
ORDER SIBLINGS BY z.sort