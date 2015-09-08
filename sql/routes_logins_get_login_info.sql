/* Formatted on 27/04/2015 13:25:40 (QP5 v5.227.12220.39724) */
SELECT t1.comm, t2.name
  FROM routes_agents_pwd t1, routes_agents t2
 WHERE t1.ag_id = t2.id AND t1.login = :login