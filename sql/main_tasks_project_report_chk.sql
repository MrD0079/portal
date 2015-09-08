/* Formatted on 28.12.2012 9:52:25 (QP5 v5.163.1008.3004) */
/*SELECT count(*)
  FROM project p
 WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
       AND parent = 0
       AND dpt_id = :dpt_id
       AND fn_get_prj_grant (p.id, :tn, 1) = 2
*/


SELECT COUNT (*)
  FROM (SELECT p.*,
               (SELECT COUNT (*) c
                  FROM project p1,
                       project p2,
                       project p3,
                       project_grant pg,
                       user_list u
                 WHERE     p1.id = p2.parent
                       AND p2.id = p3.parent
                       AND p2.id = pg.prj_node_id
                       AND (pg.pos = u.pos_id OR pg.tn = u.tn)
                       AND u.dpt_id = p1.dpt_id
                       AND (pg.otv = 1)
                       AND (u.tn IN (SELECT slave
                                       FROM full
                                      WHERE master = :tn AND full IN (0, 1))
                            OR fn_get_prj_node_grant (p2.id,
                                                      :tn,
                                                      1,
                                                      1) = 2)
                       AND u.datauvol IS NULL
                       AND p1.id = p.id
                       AND NVL ( (SELECT DECODE (completed_dt, NULL, 0, 1)
                                    FROM project_report
                                   WHERE prj_node_id = p3.id AND tn = u.tn),
                                0) = 0)
                  c
          FROM project p
         WHERE     TRUNC (SYSDATE) <= fn_get_prj_max_dt_fin (id)
               AND parent = 0
               AND dpt_id = :dpt_id
               AND ( (SELECT SUM (fn_get_prj_grant (p.id, slave, 1))
                        FROM full
                       WHERE master = :tn AND full IN (0, 1)) <> 0
                    OR fn_get_prj_grant (p.id, :tn, 1) = 2))
 WHERE c <> 0