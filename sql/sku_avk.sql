SELECT sa.id_num id, sa.*
FROM sku_avk sa
WHERE lower(sa.name) LIKE lower('%:name_p%')
OR sa.sku_id LIKE :query
OR sa.tag_id LIKE :query
ORDER BY sa.name