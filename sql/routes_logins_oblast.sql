/* Formatted on 22.08.2012 14:41:36 (QP5 v5.163.1008.3004) */
  SELECT s.*, a.name, u.comm
    FROM routes_logins_oblast s, routes_agents_pwd u, routes_agents a
   WHERE s.login = u.login AND u.ag_id = a.id
ORDER BY oblast, a.name, s.login