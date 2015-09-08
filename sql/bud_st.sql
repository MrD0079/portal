  SELECT z.id,z.name,z.lu
    FROM bud_st z
   where dpt_id=:dpt_id
ORDER BY name