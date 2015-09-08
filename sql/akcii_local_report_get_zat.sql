/* Formatted on 19/02/2015 17:40:36 (QP5 v5.227.12220.39724) */
SELECT DECODE (NVL (m.summa, 0), 0, 0, t.bonus_sum / m.summa * 100) zat
  FROM a14mega m, bud_ru_zay z, akcii_local_tp t
 WHERE     z.id = :z_id
       AND m.tp_kod = :tp_kod
       AND m.tp_kod = t.tp_kod
       AND z.id = t.z_id
       AND TRUNC (z.dt_start, 'mm') = m.dt