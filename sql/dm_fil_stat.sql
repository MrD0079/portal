/* Formatted on 06/10/2015 17:41:04 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT l.tn,
                  l.bud_id,
                  l.data,
                  l.data_t,
                  l.data8,
                  l.dm,
                  l.dwtc,
                  l.current_week,
                  s.val,
                  u.fio,
                  bud.name bud_name
    FROM (SELECT c.data,
                 TO_CHAR (c.data, 'dd.mm.yyyy') data_t,
                 TO_CHAR (c.data, 'ddmmyyyy') data8,
                 c.dm,
                 c.dwtc,
                 CASE
                    WHEN c.wy = (SELECT wy
                                   FROM calendar
                                  WHERE data = TRUNC (SYSDATE))
                    THEN
                       1
                 END
                    current_week,
                 df.tn,
                 df.bud_id
            FROM calendar c, dm_fil df
           WHERE TRUNC (c.data, 'mm') = TO_DATE ( :dt, 'dd.mm.yyyy')) l,
         user_list u,
         bud_fil bud,
         (SELECT *
            FROM dm_fil_stat
           WHERE TRUNC (dt, 'mm') = TO_DATE ( :dt, 'dd.mm.yyyy')) s,
         bud_tn_fil f
   WHERE     f.bud_id = l.bud_id
         AND l.tn = s.tn(+)
         AND l.bud_id = s.bud_id(+)
         AND l.data = s.dt(+)
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
ORDER BY bud_name, fio, data