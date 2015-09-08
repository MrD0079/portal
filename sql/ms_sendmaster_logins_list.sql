/* Formatted on 10/10/2014 17:38:55 (QP5 v5.227.12220.39724) */
  SELECT p.login, a.name, p.comm
    FROM routes_agents_pwd p, routes_agents a
   WHERE p.ag_id = a.id AND (:ag = 0 OR a.id = :ag)
ORDER BY a.name, p.comm, p.login