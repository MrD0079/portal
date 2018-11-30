  SELECT sa.id_num id, sa.*
  FROM PERSIK.sku_avk sa
  INNER JOIN PERSIK.bud_ru_zay_sku_avk bsa ON sa.id_num IN bsa.sku_id
  WHERE bsa.z_id = :z_id AND bsa.status = 1
  ORDER BY sa.name