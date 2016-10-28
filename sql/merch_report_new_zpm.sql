/* Formatted on 12/11/2015 11:52:44 (QP5 v5.252.13127.32867) */
  SELECT m.part1 part1_needed,
         m.part2 part2_needed,
         c.mt || ' ' || c.y period,
         MIN (CASE WHEN m.part1 = 1 AND z.pin = z.part1_pin THEN 1 ELSE 0 END)
            part1_ok,
         MIN (CASE WHEN m.part2 = 1 AND z.pin = z.part2_pin THEN 1 ELSE 0 END)
            part2_ok,
         CASE
            WHEN    (    m.part1 = 1
                     AND MIN (
                            CASE
                               WHEN m.part1 = 1 AND z.pin = z.part1_pin THEN 1
                               ELSE 0
                            END) = 1)
                 OR (    m.part1 = 1
                     AND MIN (
                            CASE
                               WHEN m.part1 = 1 AND z.pin = z.part1_pin THEN 1
                               ELSE 0
                            END) = 1)
            THEN
               1
         END
            all_ok
    FROM mr_zp z,
         mr_zpm m,
         calendar c,
         routes_head h
   WHERE /*m.dt = TRUNC (TO_DATE (:month_list, 'dd.mm.yyyy'), 'mm')
     AND */
        m    .dt = c.data
         AND h.id = z.head_id
         AND m.dt = h.data
         AND z.head_id IN (    SELECT id
                                FROM routes_head
                          START WITH id = :head_id
                          CONNECT BY PRIOR parent = id)
         AND z.pin IS NOT NULL
/*
         AND (   (m.part1 = 1 AND NVL (z.pin, 0) <> NVL (z.part1_pin, 0))
              OR (m.part2 = 1 AND NVL (z.pin, 0) <> NVL (z.part2_pin, 0)))
*/
GROUP BY m.part1,
         m.part2,
         c.mt,
         c.y
ORDER BY c.y, c.mt