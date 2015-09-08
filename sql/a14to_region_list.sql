/* Formatted on 28/11/2014 17:42:01 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.region_name
    FROM user_list u, a14to t
   WHERE     t.tab_num = u.tab_num
         AND u.region_name IS NOT NULL
         AND u.dpt_id = :dpt_id
ORDER BY u.region_name