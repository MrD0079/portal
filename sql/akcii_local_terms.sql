/* Formatted on 28/04/2014 13:40:34 (QP5 v5.227.12220.39724) */
SELECT zf1.val_string, zf2.val_textarea
  FROM bud_ru_zay_ff zf1,
       bud_ru_zay_ff zf2,
       bud_ru_ff f1,
       bud_ru_ff f2
 WHERE     zf1.z_id = :z_id
       AND zf2.z_id = :z_id
       AND zf1.ff_id = f1.id
       AND f1.admin_id = 1
       AND zf2.ff_id = f2.id
       AND f2.admin_id = 2