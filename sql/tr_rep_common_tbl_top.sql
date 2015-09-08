/* Formatted on 30.07.2013 15:44:20 (QP5 v5.227.12220.39724) */
  SELECT pos_id, pos_name, COUNT (*) cnt
    FROM user_list u
   WHERE is_spd = 1 AND datauvol IS NULL AND dpt_id = :dpt_id
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', u.region_name)
         AND DECODE (:department_name, '0', '0', :department_name) =
                DECODE (:department_name, '0', '0', u.department_name)
GROUP BY pos_id, pos_name
ORDER BY pos_id, pos_name