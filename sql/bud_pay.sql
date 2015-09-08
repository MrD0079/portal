  SELECT z.id,z.name,z.lu
    FROM bud_pay z
   where dpt_id=:dpt_id
ORDER BY name