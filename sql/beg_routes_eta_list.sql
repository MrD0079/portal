/* Formatted on 07/04/2015 11:34:12 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT r.h_eta, r.eta
    FROM routes r, user_list u, departments d
   WHERE     r.tab_number = u.tab_num
         AND u.dpt_id = :dpt_id
         AND u.datauvol IS NULL
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
ORDER BY r.eta