/* Formatted on 24.10.2012 13:34:25 (QP5 v5.163.1008.3004) */
  SELECT z.id,
         z.name,
         g.tn,
         g.pos,
         g.otv,
         g.chk,
         DECODE (g.otv, 1, fn_getname ( g.tn)) fio_otv,
         DECODE (g.chk, 1, fn_getname ( g.tn)) fio_chk,
         DECODE (g.otv,
                 1, (SELECT pos_name
                       FROM pos
                      WHERE pos_id = g.pos))
            pos_otv,
         DECODE (g.chk,
                 1, (SELECT pos_name
                       FROM pos
                      WHERE pos_id = g.pos))
            pos_chk,
         g.id grant_id
    FROM project z, project_grant g
   WHERE z.PARENT = :prj_id AND z.id = g.prj_node_id(+)
ORDER BY z.sort,fio_otv,fio_chk,pos_otv,pos_chk