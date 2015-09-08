/* Formatted on 21.11.2012 16:35:54 (QP5 v5.163.1008.3004) */
  SELECT p1.tn p1_tn,
         p1.fio p1_fio,
         p1.pos_name p1_pos_name,
         p1.p2_id p1_p2_id,
         p1.p2_name p1_p2_name,
         p1.p2_sort p1_p2_sort,
         p1.p3_id p1_p3_id,
         p1.p3_name p1_p3_name,
         p1.p3_sort p1_p3_sort,
         TO_CHAR (p1.dt_end, 'dd/mm/yyyy') p1_dt_end,
         p2.*
    FROM (SELECT *
            FROM (SELECT DISTINCT u.tn, u.fio, u.pos_name
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
                         AND (u.tn IN (SELECT slave
                                         FROM full
                                        WHERE master = :exp_list_without_ts)
                              OR :exp_list_without_ts = 0)
                         AND p1.id = :prj_id) px0,
                 (SELECT DISTINCT p2.id p2_id,
                                  p2.name p2_name,
                                  p2.sort p2_sort,
                                  p3.id p3_id,
                                  p3.name p3_name,
                                  p3.sort p3_sort,
                                  p3.dt_end
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
                         AND (u.tn IN (SELECT slave
                                         FROM full
                                        WHERE master = :exp_list_without_ts)
                              OR :exp_list_without_ts = 0)
                         AND p1.id = :prj_id) px1) p1,
         (SELECT u1.tn,
                 u1.p2_name,
                 u1.p3_name,
                 u1.p2_id,
                 u1.p3_id,
                 u1.dt_end,
                 TO_CHAR (pr1.completed_dt, 'dd/mm/yyyy hh24:mi:ss') completed_dt,
                 TO_CHAR (pr1.ok_chief_dt, 'dd/mm/yyyy hh24:mi:ss') ok_chief_dt,
                 pr1.completed_tn,
                 pr1.ok_chief_tn,
                 pr1.text,
                 fn_getname ( pr1.completed_tn) completed_fio,
                 fn_getname ( pr1.ok_chief_tn) ok_chief_fio,
                 DECODE (pr1.completed_dt, NULL, 0, 1) completed,
                 DECODE (pr1.completed_dt, NULL, 0, DECODE (SIGN (u1.dt_end - TRUNC (pr1.completed_dt)), -1, 0, 1)) vsrok,
                 DECODE (pr1.completed_dt, NULL, 0, DECODE (SIGN (u1.dt_end - TRUNC (pr1.completed_dt)), -1, 1, 0)) prosroch
            FROM (SELECT p2.id p2_id,
                         p2.name p2_name,
                         p3.id p3_id,
                         p3.name p3_name,
                         p3.dt_end,
                         u.tn
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
                         AND (pg.otv = 1                                                                                                                                      /* OR pg.chk * u.tn <> 0*/
                                        )
                         /*AND (u.tn IN (SELECT slave
                                         FROM full
                                        WHERE master = :tn)
                              OR pg.chk * u.tn <> 0)*/
                         AND (u.tn IN (SELECT slave
                                         FROM full
                                        WHERE master = :tn AND full IN (0, 1))
                              OR fn_get_prj_node_grant (p2.id,
                                                        :tn,
                                                        1,
                                                        1) = 2)
                         AND u.datauvol IS NULL
                         AND (u.tn IN (SELECT slave
                                         FROM full
                                        WHERE master = :exp_list_without_ts)
                              OR :exp_list_without_ts = 0)
                         AND p1.id = :prj_id) u1,
                 project_report pr1
           WHERE u1.tn = pr1.tn(+) AND u1.p3_id = pr1.prj_node_id(+)) p2
   WHERE p1.p2_id = p2.p2_id(+) AND p1.p3_id = p2.p3_id(+) AND p1.tn = p2.tn(+)
ORDER BY p1.p2_sort,
         p1.p3_sort,
         p1.fio,
         p1.p2_name,
         p1.p3_name