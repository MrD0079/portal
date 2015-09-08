/* Formatted on 31/10/2014 17:55:32 (QP5 v5.227.12220.39724) */
SELECT z.*,
       TO_CHAR (z.dt_start, 'dd.mm.yyyy') dt_start,
       TO_CHAR (z.dt_end, 'dd.mm.yyyy') dt_end,
       u.dpt_id
  FROM bud_ru_zay z, user_list u
 WHERE u.tn = z.tn AND z.id = :z_id