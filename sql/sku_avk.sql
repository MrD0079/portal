 :pagination_head
        SELECT
          DISTINCT sa.sku_id id,
            sa.id_num,
            sa.name,
            sa.name_brand,
            sa.sku_id,
            sa.tag_id,
          NVL((SELECT ss.price FROM sku_avk_prime_cost ss,
            (SELECT sku_id, CONCAT(sku_id,MAX(date_s)) sku_date
                  FROM (
                      SELECT *
                      FROM sku_avk_prime_cost
                      WHERE trunc(date_s) <= trunc(sysdate)
                  )
                  GROUP BY sku_id
              ) mss
            WHERE CONCAT(ss.sku_id,ss.date_s) = mss.sku_date AND mss.sku_id = sa.sku_id
            ),0) price_ss ,
          NVL((SELECT fs.price FROM sku_avk_free_sell_uk fs WHERE fs.sku_id = sa.sku_id  AND fs.currency = 980),0) price_urkaine,
          NVL((SELECT kk.price FROM sku_avk_kk_price kk WHERE kk.sku_id = sa.sku_id AND kk.network_id = :net_id),0) price_one,
          0 price_s_kk,
          0 logistic_expens_m_plan,
          0 all_company_expenses,
          0 mark_cost_plan_cur_m
        FROM sku_avk sa , bud_ru_zay_sku_avk bsa
        WHERE (:show_q = 0 OR (lower(sa.name) LIKE lower('%:name_p%')
              OR sa.sku_id LIKE :query
              OR sa.tag_id LIKE :query))
           AND (:show_list = 0
              OR (sa.sku_id in (:sku_list)))
          AND (:show_save_list = 0 OR (bsa.z_id = :z_id AND bsa.status = 1 AND sa.sku_id IN bsa.sku_id))

        ORDER BY sa.name
  :pagination_footer