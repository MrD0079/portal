/* Formatted on 07/04/2015 11:35:09 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.department_name
    FROM routes r,
         user_list u,
         sc_tp t,
         departments d
   WHERE     r.tab_number = u.tab_num
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
         /*AND u.datauvol IS NULL*/
         AND u.dpt_id = :dpt_id
         AND :dpt_id = t.dpt_id(+)
         AND r.tp_kod = t.tp_kod(+)
         AND TRIM (u.region_name) IS NOT NULL
         AND u.tn > 0
ORDER BY u.department_name