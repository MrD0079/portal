SELECT z.id, n.ID_NET, n.NET_NAME, z.DT_START, z.DT_END,
sku.NAME_BRAND, r_sku.SKU_NAME, (R_SKU.SKU_WEIGHT_TOTAL /*/ 1000*/) AS SKU_SALES_WEIGHT, (R_SKU.SKU_SALES_TOTAL /*/ 1000*/) AS SKU_SALES_COST,
  z.fact_sales AS fact_sales_total, z.discount AS discount_total, NULL discount_net,
  ('files/bud_ru_zay_files/' || Z.ID || '/sup_doc/' || Z.SUP_DOC) AS filePath
FROM ( SELECT Z.ID,
         z.ID_NET,
         Z.DT_START,
         Z.DT_END,
         Z.SUP_DOC,
         MAX(Z.FACT_SALES) AS FACT_SALES,
         MAX(Z.DISCOUNT) AS DISCOUNT
       FROM (SELECT Z.ID,
               z.ID_NET,
               Z.DT_START,
               Z.DT_END,
               Z.SUP_DOC,
               NVL(zf.REP_VAL_NUMBER, 0) AS FACT_SALES,
               0 DISCOUNT
             FROM BUD_RU_ZAY Z
               JOIN BUD_RU_ZAY_FF zf
                 ON zf.Z_ID = Z.ID
               JOIN BUD_RU_FF ff
                 ON zf.FF_ID = ff.ID
             WHERE Z.DT_START BETWEEN TO_DATE(:akcii_start, 'dd.mm.yyyy hh24:mi:ss') AND TO_DATE(:akcii_end, 'dd.mm.yyyy hh24:mi:ss')
                   AND 1 = (SELECT AC.REP_ACCEPTED
                            FROM BUD_RU_ZAY_ACCEPT AC
                            WHERE AC.Z_ID = z.id
                                  AND AC.ACCEPT_ORDER = (SELECT MAX(ACCEPT_ORDER)
                                                         FROM BUD_RU_ZAY_ACCEPT
                                                         WHERE Z_ID = AC.Z_ID
                                                               AND REP_ACCEPTED IS NOT NULL
                                                               AND INN_NOT_REPORTMA(TN) = 0))
                   AND ff.ID = 19311383 /* ФАКТ обьем грн */
             UNION
             SELECT Z.ID,
               z.ID_NET,
               Z.DT_START,
               Z.DT_END,
               Z.SUP_DOC,
               0 FACT_SALES,
               NVL(zf.VAL_NUMBER, 0) AS DISCOUNT
             FROM BUD_RU_ZAY Z
               JOIN BUD_RU_ZAY_FF zf
                 ON zf.Z_ID = Z.ID
               JOIN BUD_RU_FF ff
                 ON zf.FF_ID = ff.ID
             WHERE Z.DT_START BETWEEN TO_DATE(:akcii_start, 'dd.mm.yyyy hh24:mi:ss') AND TO_DATE(:akcii_end, 'dd.mm.yyyy hh24:mi:ss')
                   AND 1 = (SELECT AC.REP_ACCEPTED
                            FROM BUD_RU_ZAY_ACCEPT AC
                            WHERE AC.Z_ID = z.id
                                  AND AC.ACCEPT_ORDER = (SELECT MAX(ACCEPT_ORDER)
                                                         FROM BUD_RU_ZAY_ACCEPT
                                                         WHERE Z_ID = AC.Z_ID
                                                               AND REP_ACCEPTED IS NOT NULL
                                                               AND INN_NOT_REPORTMA(TN) = 0))
                   AND ff.ID = 176933669 /* % скидка/компенсация */ ) Z
       WHERE z.DT_START BETWEEN TO_DATE(:akcii_start, 'dd.mm.yyyy hh24:mi:ss') AND TO_DATE(:akcii_end, 'dd.mm.yyyy hh24:mi:ss')

             AND (SELECT COUNT(*)
                  FROM BUD_RU_ZAY_FF
                  WHERE Z_ID = z.id
                        AND FF_ID = 19311379
                        AND (
                          LOWER(VAL_TEXTAREA) LIKE '%штраф%'
                          /*OR LOWER(VAL_TEXTAREA) LIKE '%омпенсироват%'
                          OR LOWER(VAL_TEXTAREA) LIKE '%для компенсац%'
                          OR LOWER(VAL_TEXTAREA) LIKE '%для поздравлени%'
                          OR LOWER(VAL_TEXTAREA) LIKE '%расход%'
                          OR LOWER(VAL_TEXTAREA) LIKE '%согласовать затраты%'*/
                          OR LOWER(VAL_TEXTAREA) LIKE '%доп.оборудован%'
                        )) = 0
       GROUP BY Z.ID,
         z.ID_NET,
         Z.DT_START,
         Z.DT_END,
         Z.SUP_DOC ) z
  JOIN NETS n ON z.ID_NET = n.ID_NET
  LEFT JOIN BUD_RU_ZAY_REPORT_SKU r_sku ON z.id = r_sku.Z_ID

  LEFT JOIN SKU_AVK sku ON sku.NAME = r_sku.SKU_NAME
WHERE n.ID_NET :id_net_report
  AND z.FACT_SALES > 0
ORDER BY n.NET_NAME, z.DT_START, z.id, sku.NAME_BRAND, sku.NAME