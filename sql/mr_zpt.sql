/* Formatted on 28/09/2015 12:28:33 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) cnt,
       SUM (z.part1_charged) part1_charged,
       SUM (z.part2_charged) part2_charged,
       SUM (z.part1_sum) part1_sum,
       SUM (z.part2_sum) part2_sum,
       SUM (CASE WHEN z.pin = z.part1_pin THEN 1 END) part1_pin_ok,
       SUM (CASE WHEN z.pin = z.part2_pin THEN 1 END) part2_pin_ok
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