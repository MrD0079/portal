/* Formatted on 27/04/2015 13:10:08 (QP5 v5.227.12220.39724) */
  SELECT s.*,
         m.net_name,
         a.name,
         u.comm
    FROM routes_logins_nets s,
         routes_agents_pwd u,
         routes_agents a,
         ms_nets m
   WHERE s.login = u.login AND u.ag_id = a.id AND m.id_net = s.id_net
ORDER BY m.net_name, a.name, s.login