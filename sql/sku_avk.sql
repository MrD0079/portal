 :pagination_head
        SELECT
          DISTINCT sa.sku_id sku_id,
            sa.id_num id,
            sa.name,
            sa.weight,
            sa.name_brand,
            sa.id_num,
            sa.tag_id,
            :bsa_fields
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
          NVL((SELECT kk.price FROM sku_avk_kk_price kk WHERE kk.sku_id = sa.sku_id AND kk.network_id = :net_id),0) price_s_kk, /* price spec-cii KK */
          0 price_one,
          NVL((SELECT nc.sum_logist FROM sku_avk_net_costs nc,
            (SELECT brand, CONCAT(brand,MAX(ym)) tmp_date
                  FROM (
                      SELECT *
                      FROM sku_avk_net_costs
                      WHERE ym <= to_number(CONCAT(to_char(sysdate,'yyyy'),to_char(sysdate,'mm')))
                  )
                  GROUP BY brand
              ) ncc
            WHERE CONCAT(nc.brand,nc.ym) = ncc.tmp_date AND lower((CAST (nc.brand AS VARCHAR2(50)))) = lower(sa.name_brand) and nc.networkID = :sw_kod),0) logistic_expens,
          NVL((SELECT nc.sum_all_costs FROM sku_avk_net_costs nc,
            (SELECT brand, CONCAT(brand,MAX(ym)) tmp_date
                  FROM (
                      SELECT *
                      FROM sku_avk_net_costs
                      WHERE ym <= to_number(CONCAT(to_char(sysdate,'yyyy'),to_char(sysdate,'mm')))
                  )
                  GROUP BY brand
              ) ncc
            WHERE CONCAT(nc.brand,nc.ym) = ncc.tmp_date AND lower((CAST (nc.brand AS VARCHAR2(50)))) = lower(sa.name_brand) and nc.networkID = :sw_kod),0) company_expenses,
          NVL((SELECT nc.sum_market FROM sku_avk_net_costs nc,
            (SELECT brand, CONCAT(brand,MAX(ym)) tmp_date
                  FROM (
                      SELECT *
                      FROM sku_avk_net_costs
                      WHERE ym <= to_number(CONCAT(to_char(sysdate,'yyyy'),to_char(sysdate,'mm')))
                  )
                  GROUP BY brand
              ) ncc
            WHERE CONCAT(nc.brand,nc.ym) = ncc.tmp_date AND lower((CAST (nc.brand AS VARCHAR2(50)))) = lower(sa.name_brand) and nc.networkID = :sw_kod),0) market_val
        FROM sku_avk sa :bsa_table
        WHERE (:show_q = 0 OR (lower(sa.name) LIKE lower('%:name_p%')
              OR sa.sku_id LIKE :query
              OR sa.tag_id LIKE :query))
           AND (:show_list = 0
              OR (sa.id_num in (:sku_list)))
          :bsa_where
        /*AND (:show_save_list = 0 OR (bsa.z_id = :z_id AND bsa.status = 1 AND sa.sku_id IN bsa.sku_id))*/
        ORDER BY sa.name
  :pagination_footer