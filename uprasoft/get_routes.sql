/* Formatted on 01.08.2013 15:18:38 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT cpp1_tz_oblast oblast,
                  rh_num route,
                  n_net_name net,
                  cpp1_tz_address address,
                  cpp1_id id
    FROM ms_rep_routes1
   WHERE rh_data = TRUNC (SYSDATE, 'mm') AND vv = 0
ORDER BY cpp1_tz_oblast,
         rh_num,
         n_net_name,
         cpp1_tz_address,
         cpp1_id