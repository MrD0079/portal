/* Formatted on 19/02/2016 10:35:20 (QP5 v5.252.13127.32867) */
  SELECT name,
         admin_id,
         var1,
         ff.dpt_id,
         d.cnt_name
    FROM bud_ru_ff ff, departments d
   WHERE admin_id IS NOT NULL AND ff.dpt_id = d.dpt_id
ORDER BY admin_id, dpt_id