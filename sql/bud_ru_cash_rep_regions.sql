/* Formatted on 11.11.2013 14:20:15 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT st_m.region_name
    FROM bud_tn_fil e, user_list st_m, bud_fil bud
   WHERE     st_m.tn = e.tn
         AND bud.id = e.bud_id
         AND st_m.is_db = 1
         AND st_m.dpt_id = bud.dpt_id
         AND st_m.dpt_id = :dpt_id
         AND TRIM (st_m.region_name) IS NOT NULL
         AND bud.dpt_id = :dpt_id
ORDER BY st_m.region_name