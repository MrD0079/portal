/* Formatted on 27/01/2016 10:25:47 (QP5 v5.252.13127.32867) */
  SELECT id, name
    FROM bud_ru_ff
   WHERE     TYPE = 'list'
         AND dpt_id = :dpt_id
         AND parent_field IS NULL
         AND id <> :id
ORDER BY name