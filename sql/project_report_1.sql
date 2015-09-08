/* Formatted on 06.11.2012 14:21:59 (QP5 v5.163.1008.3004) */
/*
2943008048 доля
2715211215 Комиссар 
2955913530 калаш
2923402273 бабец
3244410396 аюбов
*/

           SELECT LEVEL,
                  z.id,
                  z.parent,
                  z.name,
                  z.lu,
                  z.sort,
                  TO_CHAR (z.dt_start, 'dd/mm/yyyy') dt_start,
                  TO_CHAR (z.dt_end, 'dd/mm/yyyy') dt_end,
                  TO_CHAR (z.dt_fin, 'dd/mm/yyyy') dt_fin,
                  fn_get_prj_node_cnt (z.id,
                                       :tn,
                                       LEVEL,
                                       :exp_list_without_ts)
                     cnt
             FROM project z
       START WITH z.id IN (SELECT DISTINCT z.id
                             FROM project z,
                                  (SELECT slave
                                     FROM full
                                    WHERE master = :tn/* and full in (0,1)*/) s
                            WHERE z.PARENT = :prj_id
                                  AND (fn_get_prj_node_grant (z.id, slave, 1) = 1
                                       OR fn_get_prj_node_grant (z.id,
                                                                 :tn,
                                                                 1,
                                                                 1) = 2))
       CONNECT BY PRIOR z.ID = z.PARENT
ORDER SIBLINGS BY z.sort