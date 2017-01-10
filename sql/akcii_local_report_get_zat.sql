/* Formatted on 10.01.2017 12:42:54 (QP5 v5.252.13127.32867) */
SELECT DECODE (NVL (m.summa, 0) + NVL (m.np, 0),
               0, 0,
               t.bonus_sum / m.summa * 100)
          zat
  FROM a14mega m, bud_ru_zay z, akcii_local_tp t
 WHERE     z.id = :z_id
       AND m.tp_kod = :tp_kod
       AND m.tp_kod = t.tp_kod
       AND z.id = t.z_id
       AND TRUNC (z.dt_start, 'mm') = m.dt