/* Formatted on 25/09/2015 18:18:38 (QP5 v5.227.12220.39724) */
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
         TO_CHAR (z.part1_lu, 'dd.mm.yyyy hh24:mi:ss') part1_lu,
         TO_CHAR (z.part2_lu, 'dd.mm.yyyy hh24:mi:ss') part2_lu,
         CASE WHEN z.pin = z.part1_pin THEN 1 END part1_pin_ok,
         CASE WHEN z.pin = z.part2_pin THEN 1 END part2_pin_ok,
         z.pin
    FROM routes_head h, spr_users u, mr_zp z
   WHERE     h.tn = u.tn
         AND h.data = TO_DATE (:month_list, 'dd.mm.yyyy')
         AND z.head_id = h.id
         /*and h.id=90598439*/
ORDER BY svms, h.num, z.fio_otv