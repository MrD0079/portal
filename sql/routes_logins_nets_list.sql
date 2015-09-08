/* Formatted on 27/04/2015 13:21:08 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT c.id_net, c.net_name, S.login
    FROM ms_nets c,
         (SELECT *
            FROM routes_logins_nets
           WHERE login = :login) s
   WHERE c.net_name IS NOT NULL AND c.id_net = s.id_net(+)
ORDER BY c.net_name