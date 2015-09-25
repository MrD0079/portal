/* Formatted on 25/09/2015 17:44:29 (QP5 v5.227.12220.39724) */
  SELECT z.fio_otv,
         z.h_fio_otv,
         m.part1,
         m.part2,
         z.part1_pin,
         z.part2_pin,
         TO_CHAR (z.part1_dt, 'dd.mm.yyyy') part1_dt,
         TO_CHAR (z.part2_dt, 'dd.mm.yyyy') part2_dt,
         z.part1_sum,
         z.part2_sum,
         z.pin
    FROM mr_zp z, mr_zpm m, routes_head h
   WHERE     z.head_id = :head_id
         AND h.id = z.head_id
         AND m.dt = h.data
/*
         AND (   (m.part1 = 1 AND NVL (z.pin, 0) <> NVL (z.part1_pin, 0))
              OR (m.part2 = 1 AND NVL (z.pin, 0) <> NVL (z.part2_pin, 0)))
*/
ORDER BY z.fio_otv