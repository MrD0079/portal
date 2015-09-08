/* Formatted on 15/12/2014 15:38:16 (QP5 v5.227.12220.39724) */
  SELECT e.*,
         u.fio,
         m.name m_name,
         u.dpt_name
    FROM dpnr_market_tn e, user_list u, dpnr_markets m
   WHERE u.tn = e.tn AND m.id = e.m_id
ORDER BY m.name, u.fio