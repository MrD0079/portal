SELECT sa.id_num id, sa.*
FROM PERSIK.sku_avk sa
WHERE sa.id_num IN (
  SELECT bsa.sku_id
  FROM PERSIK.bud_ru_zay_sku_avk bsa
  WHERE bsa.z_id = :z_id
  AND bsa.status = 1
)
ORDER BY sa.name