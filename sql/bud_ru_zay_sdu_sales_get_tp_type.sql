/* Formatted on 18/05/2016 17:35:42 (QP5 v5.252.13127.32867) */
SELECT DECODE (zff.val_list,  100027437, 'tp',  100027436, 'net') tp_type
  FROM bud_ru_ff ff, bud_ru_zay_ff zff
 WHERE zff.z_id = :z_id AND zff.ff_id = ff.id AND ff.admin_id = 13