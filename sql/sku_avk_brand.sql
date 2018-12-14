 :pagination_head
        SELECT
          DISTINCT br.brand_id id,
            br.name
        FROM sku_avk_brand br
        WHERE lower(br.name) LIKE lower('%:brand_name%')
              OR br.brand_id LIKE :brand_id
        ORDER BY br.name
  :pagination_footer