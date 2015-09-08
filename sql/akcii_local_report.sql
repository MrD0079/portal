/* Formatted on 25/06/2015 11:42:05 (QP5 v5.227.12220.39724) */
SELECT c.y,
       c.mt,
       f.name fil,
       zf1.val_string,
       zf2.val_textarea,
       bst.ok_db_tn
  FROM bud_ru_zay z,
       bud_ru_zay_ff zf1,
       bud_ru_zay_ff zf2,
       bud_ru_ff f1,
       bud_ru_ff f2,
       calendar c,
       bud_fil f,
       bud_svod_taf bst
 WHERE     z.id = :z_id
       AND zf1.z_id = z.id
       AND zf2.z_id = z.id
       AND zf1.ff_id = f1.id
       AND f1.admin_id = 1
       AND zf2.ff_id = f2.id
       AND f2.admin_id = 2
       AND TRUNC (z.dt_start, 'mm') = c.data
       AND f.id = z.fil
       AND TRUNC (z.dt_start, 'mm') = bst.dt(+)
       AND z.fil = bst.fil(+)