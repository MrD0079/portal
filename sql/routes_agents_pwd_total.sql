/* Formatted on 24.07.2012 13:23:07 (QP5 v5.163.1008.3004) */
  SELECT a.id, a.name, COUNT (h.id) c
    FROM routes_agents_pwd h, spr_users s, routes_agents a
   WHERE h.login = S.LOGIN AND a.id = h.ag_id
GROUP BY a.id, a.name
order by a.name