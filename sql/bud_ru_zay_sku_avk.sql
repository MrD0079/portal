  SELECT
    sa.sku_id id,
    sa.*,
    1 price_ss,
    2 price_urkaine,
    3 price_s_kk,
    4 price_one,
    5 price_one_discount,
    6 logistic_expens_m_plan,
    7 all_company_expenses,
    8 mark_cost_plan_cur_m
  FROM PERSIK.sku_avk sa
  INNER JOIN PERSIK.bud_ru_zay_sku_avk bsa ON sa.sku_id IN bsa.sku_id
  WHERE bsa.z_id = :z_id AND bsa.status = 1
  ORDER BY sa.name