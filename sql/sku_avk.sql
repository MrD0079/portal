SELECT
  sa.id_num id,
  sa.*,
  1 price_ss,
  2 price_urkaine,
  3 price_s_kk,
  4 price_one,
  5 price_one_discount,
  6 logistic_expens_m_plan,
  7 all_company_expenses,
  8 mark_cost_plan_cur_m
FROM sku_avk sa
WHERE lower(sa.name) LIKE lower('%:name_p%')
OR sa.sku_id LIKE :query
OR sa.tag_id LIKE :query
ORDER BY sa.name