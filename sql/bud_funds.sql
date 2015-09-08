/* Formatted on 18/05/2015 18:18:29 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         z.name,
         z.lu,
         z.planned,
         z.norm,
         z.kod
    FROM bud_funds z
   WHERE dpt_id = :dpt_id
ORDER BY name