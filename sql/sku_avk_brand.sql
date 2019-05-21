 :pagination_head
        SELECT
          DISTINCT br.brand_id id,
            br.name
            ,(case when nvl(br.status,0) = 1 then 0 else 1 END) as disabled
        FROM sku_avk_brand br
        WHERE lower(br.name) LIKE lower('%:brand_name%')
              OR br.brand_id LIKE :brand_id
        ORDER BY br.name
  :pagination_footer