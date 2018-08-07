/* Formatted on 05/08/2018 12:34:30 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT u.region_name
    FROM user_list u, a18to t
   WHERE     t.tab_num = u.tab_num
         AND u.region_name IS NOT NULL
         AND u.dpt_id = :dpt_id
ORDER BY u.region_name;