/* Formatted on 22.07.2014 13:21:11 (QP5 v5.227.12220.39724) */
SELECT           --sum(nvl(odometr_end,0)-nvl(odometr_start,0)) odometr_delta,
      SUM (PET_VOL) PET_VOL,
       SUM (PET_SUM) PET_SUM,
       SUM (OIL_VOL) OIL_VOL,
       SUM (OIL_SUM) OIL_SUM,
       SUM (WASH) WASH,
       SUM (SERVICE) SERVICE,
       SUM (PARKING) PARKING,
       SUM (
            NVL (PET_SUM, 0)
          + NVL (OIL_SUM, 0)
          + NVL (WASH, 0)
          + NVL (SERVICE, 0)
          + NVL (PARKING, 0))
          zc_total,
       --       SUM (TIME_TOTAL) TIME_TOTAL,
       SUM (NIGHTS_COUNT) NIGHTS_COUNT,
       SUM (DAYS_COUNT) DAYS_COUNT,
       SUM (DAILY_COST) DAILY_COST,
       SUM (FOOD) FOOD,
       SUM (HOTEL) HOTEL,
       SUM (TRANSPORT) TRANSPORT,
       SUM (
            NVL (DAILY_COST, 0)
          + NVL (FOOD, 0)
          + NVL (HOTEL, 0)
          + NVL (TRANSPORT, 0))
          zt_total,
       SUM (DECODE (tr.data, NULL, NULL, 1)) tr,
       SUM (DECODE (dc.data, NULL, NULL, 1)) dc
  FROM calendar c,
       zat_daily_car zc,
       zat_daily_trip zt,
       p_activ_plan_daily p,
       (SELECT DISTINCT c.data
          FROM tr,
               tr_order_head h,
               tr_order_body b,
               calendar c
         WHERE     h.ok_final = 1
               AND b.head = h.id
               AND b.manual >= 0
               AND b.completed = 1
               AND tr.id = h.tr
               AND b.tn = :tn
               AND c.data BETWEEN h.dt_start AND h.dt_start + days - 1) tr,
       (SELECT DISTINCT c.data
          FROM dc_order_head h, dc_order_body b, calendar c
         WHERE     b.head = h.id
               AND b.manual >= 0
               AND b.tn = :tn
               AND c.data = h.dt_start) dc,
       (SELECT c1.data
          FROM vacation v, calendar c1
         WHERE     NVL (
                      (SELECT accepted
                         FROM sz_accept
                        WHERE     sz_id = v.sz_id
                              AND accept_order =
                                     DECODE (
                                        NVL (
                                           (SELECT accept_order
                                              FROM sz_accept
                                             WHERE     sz_id = v.sz_id
                                                   AND accepted = 2),
                                           0),
                                        0, (SELECT MAX (accept_order)
                                              FROM sz_accept
                                             WHERE sz_id = v.sz_id),
                                        (SELECT accept_order
                                           FROM sz_accept
                                          WHERE     sz_id = v.sz_id
                                                AND accepted = 2))),
                      0) = 1
               AND c1.data BETWEEN v.v_from AND v.v_to
               AND v.tn = :tn) vac
 WHERE     TRUNC (c.data, 'mm') =                             /*'01.08.2011'*/
                                 TO_DATE (:sd, 'dd.mm.yyyy')
       --AND wm = :week
       --AND dw <> 7
       AND c.data = zc.data(+)
       AND c.data = zt.data(+)
       AND c.data = p.data(+)
       AND :tn = zc.tn(+)
       AND :tn = zt.tn(+)
       AND :tn = p.tn(+)
       AND c.data = tr.data(+)
       AND c.data = dc.data(+)
       AND c.data = vac.data(+)