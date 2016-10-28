/* Formatted on 12/11/2015 12:11:38 (QP5 v5.252.13127.32867) */
  SELECT z.head_id,
         z.fio_otv,
         z.h_fio_otv,
         c.mt || ' ' || c.y period,
         CASE WHEN m.part1 = 1 AND z.pin = z.part1_pin THEN 1 ELSE 0 END
            part1_ok,
         CASE WHEN m.part2 = 1 AND z.pin = z.part2_pin THEN 1 ELSE 0 END
            part2_ok,
         m.part1,
         m.part2,
         z.part1_pin,
         z.part2_pin,
         TO_CHAR (z.part1_dt, 'dd.mm.yyyy') part1_dt,
         TO_CHAR (z.part2_dt, 'dd.mm.yyyy') part2_dt,
         z.part1_sum,
         z.part2_sum,
         z.pin
    FROM mr_zp z,
         mr_zpm m,
         calendar c,
         routes_head h
   WHERE     m.dt = c.data
         AND h.id = z.head_id
         AND m.dt = h.data
         AND z.head_id IN (    SELECT id
                                 FROM routes_head
                           START WITH id = :head_id
                           CONNECT BY PRIOR parent = id)
         AND z.pin IS NOT NULL
ORDER BY c.y, c.my, z.fio_otv