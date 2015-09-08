/* Formatted on 06/07/2015 12:11:26 (QP5 v5.227.12220.39724) */
  SELECT ra.name ag_name,
         ra.id ag_id,
         da.id,
         TO_CHAR (da.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         da.lu_fio,
         da.sku_price
    FROM merch_dt_ag da, routes_agents ra
   WHERE ra.id = da.ag_id(+) AND da.dt(+) = TO_DATE (:sd, 'dd.mm.yyyy')
ORDER BY ra.name