/* Formatted on 09.07.2014 12:28:42 (QP5 v5.227.12220.39724) */
  SELECT a.id,
         a.name,
         h.login,
         s.password,
         h.comm,
         h.email,
         h.is_super,h.is_so,h.is_vf,h.stat
    FROM routes_agents_pwd h, spr_users s, routes_agents a
   WHERE h.login = S.LOGIN AND a.id = h.ag_id
ORDER BY a.name, h.login