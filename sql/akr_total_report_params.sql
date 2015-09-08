/* Formatted on 12.02.2013 11:36:36 (QP5 v5.163.1008.3004) */
  SELECT p.id,
         p.name,
         NVL (z.val, 0) val,
         (SELECT name
            FROM akr_balls
           WHERE id = NVL (z.val, 0))
            ball
    FROM akr_ocenka_params p, akr_tz_report_params z
   WHERE p.id = z.prm_id(+) AND z.rep_id(+) = :id
ORDER BY p.name