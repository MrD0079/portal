/* Formatted on 21/10/2015 18:03:16 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT s.id,
                  s.fn,
                  l.tn,
                  l.bud_id
    FROM dm_fil l,
         user_list u,
         bud_fil bud,
         dm_fil_stat_files s,
         bud_tn_fil f
   WHERE     f.bud_id = l.bud_id
         AND l.tn = s.tn
         AND l.bud_id = s.bud_id
         AND TRUNC (s.dt, 'mm') = TO_DATE ( :dt, 'dd.mm.yyyy')
         AND u.tn = l.tn
         AND bud.id = l.bud_id
         AND (   f.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_dm, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND ( :bud_id = 0 OR :bud_id = l.bud_id)
         AND ( :fils = 0 OR :fils = DECODE ( :tn, l.tn, 1))
         AND ( :dm = 0 OR :dm = l.tn)
ORDER BY s.fn