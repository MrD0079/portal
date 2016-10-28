/* Formatted on 15/02/2016 12:41:57 (QP5 v5.252.13127.32867) */
SELECT zff.val_file, zff.ff_id, zff.z_id
  FROM bud_ru_zay_ff zff, bud_ru_ff ff, bud_ru_zay z
 WHERE     z.id = :z_id
       AND zff.z_id = z.id
       AND zff.ff_id = ff.id
       AND ff.TYPE = 'file'