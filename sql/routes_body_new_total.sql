/* Formatted on 14.01.2014 23:00:11 (QP5 v5.227.12220.39724) */
  SELECT SUM (rb.DAY_ENABLED_MR) DAY_ENABLED_MR,
         SUM (rb.DAY_TIME_MR) DAY_TIME_MR,
         /*SUM (rb.DAY_ENABLED_f) DAY_ENABLED_f,
         SUM (rb.DAY_TIME_f) DAY7_TIME_f,*/
         rb.day_num
    FROM (SELECT cpp1.*, a.id ag_id, a.name ag_name
            FROM cpp cpp1,
                 (SELECT *
                    FROM svms_oblast
                   WHERE tn = (SELECT tn
                                 FROM routes_head
                                WHERE id = :route)) s,
                 (SELECT *
                    FROM routes_head_agents
                   WHERE HEAD_ID = :route AND vv = 0) ha,
                 routes_agents a
           WHERE cpp1.tz_oblast = s.oblast AND A.ID = HA.AG_ID) cpp,
         (SELECT *
            FROM routes_body1
           WHERE head_id = :route AND vv = 0) rb,
         routes_tp rt
   WHERE     cpp.kodtp = rb.kodtp(+)
         AND cpp.ag_id = rb.ag_id(+)
         AND cpp.kodtp = rt.kodtp
         AND rt.head_id = :route
         AND rt.vv = 0
GROUP BY rb.day_num