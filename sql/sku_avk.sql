SELECT
  sa.sku_id id,
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
    ),0) price_ss,
  NVL((SELECT fs.price FROM sku_avk_free_sell_uk fs WHERE fs.sku_id = sa.sku_id  AND fs.currency = 980),0) price_urkaine,
  NVL((SELECT kk.price FROM sku_avk_kk_price kk WHERE kk.sku_id = sa.sku_id AND kk.network_id = :net_id),0) price_s_kk,
  4 price_one,
  5 price_one_discount,
  6 logistic_expens_m_plan,
  7 all_company_expenses,
  8 mark_cost_plan_cur_m
FROM sku_avk sa
WHERE (:show_q = 0 OR (lower(sa.name) LIKE lower('%:name_p%')
      OR sa.sku_id LIKE :query
      OR sa.tag_id LIKE :query))
   AND (:show_list = 0
      OR sa.sku_id in (:sku_list))

ORDER BY sa.name
  /*
  SELECT
  sa.sku_id id,
  sa.id_num,
  sa.name,
  sa.name_brand,
  sa.sku_id,
  sa.tag_id,
  DECODE(pc.price, null, 0, pc.price) price_ss,
  DECODE(fs.price, null, 0, fs.price) price_urkaine,
  DECODE(kk.price, null, 0, kk.price) price_s_kk,
  4 price_one,
  5 price_one_discount,
  6 logistic_expens_m_plan,
  7 all_company_expenses,
  8 mark_cost_plan_cur_m
FROM sku_avk sa
, (
          SELECT ss.* FROM SKU_AVK_PRIME_COST ss,(
            SELECT sku_id, CONCAT(sku_id,MAX(date_s)) sku_date
                FROM (
                    SELECT *
                    FROM SKU_AVK_PRIME_COST
                    WHERE to_date(date_s, 'dd.mm. yyyy') <= to_date(sysdate,'dd.mm. yyyy')
                )
                GROUP BY sku_id
            ) mss
          WHERE CONCAT(ss.sku_id,ss.date_s) = mss.sku_date
    ) pc
, SKU_AVK_FREE_SELL_UK fs
, SKU_AVK_KK_PRICE kk
WHERE (lower(sa.name) LIKE lower('%:name_p%')
  OR sa.sku_id LIKE :query
  OR sa.tag_id LIKE :query)
  AND pc.sku_id IN sa.sku_id
  AND kk.network_id = 11
  AND fs.currency = 980
  AND pc.sku_id = sa.sku_id
  AND fs.sku_id = sa.sku_id
  AND kk.sku_id = sa.sku_id
ORDER BY sa.name*/