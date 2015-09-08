/* Formatted on 20.08.2012 16:47:50 (QP5 v5.163.1008.3004) */
  SELECT a.*, DECODE (ha.id, NULL, 0, 1) checked
    FROM (SELECT *
            FROM routes_head_agents
           WHERE vv = 0) ha,
         routes_agents a
   WHERE hA.HEAD_ID(+) = :route AND A.ID = HA.AG_ID(+)
ORDER BY a.name