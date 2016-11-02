/* Formatted on 02.11.2016 17:10:45 (QP5 v5.252.13127.32867) */
  SELECT cse.*,
         NVL (zc.total, 0) + NVL (zt.total, 0) + NVL (zm.total, 0) total,
         NVL (zc.total, 0) + NVL (zm.amort, 0) + NVL (zm.gbo_warmup_sum, 0)
            total_c,
         NVL (zt.total, 0) total_t,
         NVL (zm.total, 0) total_m,
         NVL (zc.PET_VOL, 0)+ NVL (zm.gbo_warmup_vol, 0) PET_VOL,
         NVL (zc.PET_SUM, 0)+ NVL (zm.gbo_warmup_sum, 0) PET_SUM,
         NVL (zc.PET_PRICE, 0) PET_PRICE,
         NVL (zc.PET_CNT, 0) PET_CNT,
         NVL (zc.OIL_SUM, 0) OIL_SUM,
         NVL (zc.WASH, 0) WASH,
         NVL (zc.SERVICE, 0) SERVICE,
         NVL (zc.PARKING, 0) PARKING,
         NVL (zt.DAILY_COST, 0) DAILY_COST,
         NVL (zt.FOOD, 0) FOOD,
         NVL (zt.HOTEL, 0) HOTEL,
         NVL (zt.TRANSPORT, 0) TRANSPORT,
         NVL (zm.amort, 0) amort,
         NVL (zm.PRESENT_COST, 0) PRESENT_COST,
         NVL (zm.STATIONERY, 0) STATIONERY,
         NVL (zm.MEDIA_ADVERT, 0) MEDIA_ADVERT,
         NVL (zm.MAIL, 0) MAIL,
         NVL (zm.CONFERENCE, 0) CONFERENCE,
         NVL (zm.TRAINING_FOOD, 0) TRAINING_FOOD,
         NVL (zm.ESV, 0) ESV,
         NVL (zm.SINGLE_TAX, 0) SINGLE_TAX,
         NVL (zm.account_payments, 0) account_payments,
         NVL (zm.mobile, 0) mobile,
         NVL (zm.odometr_delta, 0) odometr_delta,
         DECODE (NVL (zm.odometr_delta, 0),
                 0, 0,
                 NVL (zc.PET_VOL, 0) / NVL (zm.odometr_delta, 0) * 100)
            rashod_fakt
    FROM (SELECT c1.dt, c1.mt, c1.y
            FROM (SELECT DISTINCT TRUNC (data, 'mm') dt, mt, y
                    FROM calendar
                   WHERE TRUNC (data, 'mm') BETWEEN ADD_MONTHS (
                                                       TO_DATE ( :sd,
                                                                'dd.mm.yyyy'),
                                                       -2)
                                                AND TO_DATE ( :sd,
                                                             'dd.mm.yyyy')) c1)
         cse,
         (  SELECT TRUNC (zc.data, 'mm') dt,
                   zc.tn,
                   SUM (
                        NVL (PET_SUM, 0)
                      + NVL (OIL_SUM, 0)
                      + NVL (WASH, 0)
                      + NVL (SERVICE, 0)
                      + NVL (PARKING, 0))
                      total,
                   SUM (PET_VOL) PET_VOL,
                   SUM (PET_SUM) PET_SUM,
                   SUM (OIL_SUM) OIL_SUM,
                   SUM (WASH) WASH,
                   SUM (SERVICE) SERVICE,
                   SUM (PARKING) PARKING,
                   DECODE (SUM (NVL (pet_vol, 0)),
                           0, 0,
                           SUM (NVL (pet_sum, 0)) / SUM (NVL (pet_vol, 0)))
                      pet_price,
                   SUM (DECODE (NVL (pet_vol, 0), 0, 0, 1)) pet_cnt
              FROM zat_daily_car zc
             WHERE     tn = :tn
                   AND TRUNC (zc.data, 'mm') BETWEEN ADD_MONTHS (
                                                        TO_DATE ( :sd,
                                                                 'dd.mm.yyyy'),
                                                        -2)
                                                 AND TO_DATE ( :sd, 'dd.mm.yyyy')
          GROUP BY TRUNC (zc.data, 'mm'), zc.tn) zc,
         (  SELECT TRUNC (zt.data, 'mm') dt,
                   zt.tn,
                   SUM (
                        +NVL (DAILY_COST, 0)
                      + NVL (FOOD, 0)
                      + NVL (HOTEL, 0)
                      + NVL (TRANSPORT, 0))
                      total,
                   SUM (DAILY_COST) DAILY_COST,
                   SUM (FOOD) FOOD,
                   SUM (HOTEL) HOTEL,
                   SUM (TRANSPORT) TRANSPORT
              FROM zat_daily_trip zt
             WHERE     tn = :tn
                   AND TRUNC (zt.data, 'mm') BETWEEN ADD_MONTHS (
                                                        TO_DATE ( :sd,
                                                                 'dd.mm.yyyy'),
                                                        -2)
                                                 AND TO_DATE ( :sd, 'dd.mm.yyyy')
          GROUP BY TRUNC (zt.data, 'mm'), zt.tn) zt,
         (SELECT TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') dt,
                 zm.*,
                   NVL (PRESENT_COST, 0)
                 + NVL (STATIONERY, 0)
                 + NVL (MEDIA_ADVERT, 0)
                 + NVL (MAIL, 0)
                 + NVL (CONFERENCE, 0)
                 + NVL (TRAINING_FOOD, 0)
                 + NVL (ESV, 0)
                 + NVL (SINGLE_TAX, 0)
                 + NVL (account_payments, 0)
                 + NVL (mobile, 0)
                    /*+ NVL (AMORT, 0)*/

                    total,
                 NVL (odometr_end, 0) - NVL (odometr_start, 0) odometr_delta
            FROM zat_monthly zm
           WHERE     tn = :tn
                 AND TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') BETWEEN ADD_MONTHS (
                                                                               TO_DATE (
                                                                                  :sd,
                                                                                  'dd.mm.yyyy'),
                                                                               -2)
                                                                        AND TO_DATE (
                                                                               :sd,
                                                                               'dd.mm.yyyy'))
         zm
   WHERE cse.dt = zm.dt(+) AND cse.dt = zt.dt(+) AND cse.dt = zc.dt(+)
ORDER BY cse.dt DESC