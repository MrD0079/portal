/* Formatted on 28/09/2015 11:51:10 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         h.num,
         z.head_id,
         u.fio svms,
         z.fio_otv,
         TO_CHAR (z.pin_lu, 'dd.mm.yyyy hh24:mi:ss') pin_lu,
         z.pin_lu_fio,
         z.part1_pin,
         z.part2_pin,
         TO_CHAR (z.part1_dt, 'dd.mm.yyyy') part1_dt,
         TO_CHAR (z.part2_dt, 'dd.mm.yyyy') part2_dt,
         z.part1_sum,
         z.part2_sum,
         z.part1_charged,
         z.part2_charged,
         TO_CHAR (z.part1_lu, 'dd.mm.yyyy hh24:mi:ss') part1_lu,
         TO_CHAR (z.part2_lu, 'dd.mm.yyyy hh24:mi:ss') part2_lu,
         CASE WHEN z.pin = z.part1_pin THEN 1 END part1_pin_ok,
         CASE WHEN z.pin = z.part2_pin THEN 1 END part2_pin_ok,
         z.pin
    FROM routes_head h, spr_users u, mr_zp z
   WHERE     h.tn = u.tn
         AND h.data = TO_DATE (:month_list, 'dd.mm.yyyy')
         AND z.head_id = h.id
         AND DECODE (:select_route_numb, 0, 0, h.id) =
                DECODE (:select_route_numb, 0, 0, :select_route_numb)
         AND DECODE (:svms_list, 0, 0, h.tn) =
                DECODE (:svms_list, 0, 0, :svms_list)
         AND DECODE (:flt_sum,
                     0, 0,
                     1, NVL (z.part1_sum, 0),
                     2, NVL (z.part2_sum, 0)) = 0
         AND DECODE (:flt_pin,
                     0, 0,
                     1, CASE WHEN z.pin = z.part1_pin THEN 1 ELSE 0 END,
                     2, CASE WHEN z.pin = z.part2_pin THEN 1 ELSE 0 END) = 0
ORDER BY svms, h.num, z.fio_otv