/* Formatted on 28.12.2012 9:51:37 (QP5 v5.163.1008.3004) */
/*SELECT count(*)
  FROM project p
 WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
       AND parent = 0
       AND dpt_id = :dpt_id
       AND ( (SELECT SUM (fn_get_prj_grant (p.id, slave, 1))
                FROM full
               WHERE master = :tn and full in (0,1)) <> 0*/

            /*OR fn_get_prj_grant (p.id, :tn, 1) = 2*/

/*)*/



/*SELECT COUNT (DISTINCT (SELECT parent
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
             WHERE     z.id = r.prj_node_id(+)
                   AND LEVEL = 2
                   AND (SELECT SUM (fn_get_prj_node_grant (z.id, slave, 2))
                          FROM full
                         WHERE master = :tn) <> 0
        START WITH z.PARENT IN (SELECT id
                                  FROM project p
                                 WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
                                       AND parent = 0
                                       AND dpt_id = :dpt_id
                                       AND (SELECT SUM (fn_get_prj_grant (p.id, slave))
                                              FROM full
                                             WHERE master = :tn) <> 0)
        CONNECT BY PRIOR z.ID = z.PARENT) z1
 WHERE completed_dt IS NULL*/


SELECT COUNT (*)
  FROM (SELECT p.*,
               (SELECT COUNT (*) c
                  FROM project p1,
                       project p2,
                       project p3,
                       project_grant pg,
                       user_list u,
                       project_report pr
                 WHERE p1.id = p2.parent AND p2.id = p3.parent AND p2.id = pg.prj_node_id AND (pg.pos = u.pos_id OR pg.tn = u.tn) AND u.dpt_id = p1.dpt_id AND (pg.otv = 1     /*or pg.chk * u.tn <> 0*/
                                                                                                                                                                          )
                       AND (u.tn IN (SELECT slave
                                       FROM full
                                      WHERE master = :tn AND full IN (0, 1))/*OR fn_get_prj_node_grant (p2.id,
                                                                                                       :tn,
                                                                                                       1,
                                                                                                       1) = 2*/
                                                                             )
                       AND u.datauvol IS NULL
                       AND p1.id = p.id
                       AND p3.id = pr.prj_node_id(+)
                       AND pr.completed_dt IS NULL)
                  c
          FROM project p
         WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
               AND parent = 0
               AND dpt_id = :dpt_id
               AND ( (SELECT SUM (fn_get_prj_grant (p.id, slave, 1))
                        FROM full
                       WHERE master = :tn AND full IN (0, 1)) <> 0/*OR fn_get_prj_grant (p.id, :tn, 1) = 2*/
                                                                   ))
 WHERE c <> 0