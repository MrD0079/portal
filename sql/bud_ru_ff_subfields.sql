/* Formatted on 16/02/2016 13:49:53 (QP5 v5.252.13127.32867) */
  SELECT ff.id, ff.name, ff.autocomplete
    FROM BUD_RU_FF_SUBTYPES ffst, BUD_RU_FF ff
   WHERE     ffst.dpt_id = ff.dpt_id
         AND ffst.id = ff.subtype
         AND ff.dpt_id = :dpt_id
         AND TYPE = 'list'
ORDER BY ff.name