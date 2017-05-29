/* Formatted on 29.05.2017 13:12:09 (QP5 v5.252.13127.32867) */
  SELECT mv.id,
         s.FAM || ' ' || s.IM || ' ' || s.OTCH fio,
         TO_CHAR (s.START_company, 'dd.mm.yyyy') START_company,
         NVL (
            (SELECT SUM (days)
               FROM ms_vac
              WHERE     login = s.login
                    AND TRUNC (vac_start, 'yyyy') = TRUNC (SYSDATE, 'yyyy') and removed is null),
            0)
            vac_days_used,
            'с '
         || TO_CHAR (mv.vac_start, 'dd.mm.yyyy')
         || ' по '
         || TO_CHAR (mv.vac_start + mv.days - 1, 'dd.mm.yyyy')
            vac_period,
         mv.creator,
         TO_CHAR (mv.created, 'dd.mm.yyyy') created,
         mv.remover,
         TO_CHAR (mv.removed, 'dd.mm.yyyy') removed
    FROM spr_users_ms s, user_list u, ms_vac mv
   WHERE     s.login = mv.login
         AND TRUNC (mv.vac_start, 'yyyy') = TRUNC (SYSDATE, 'yyyy')
         AND s.chief = u.tn
         AND u.pos_id = 69
         AND u.dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (u.datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND s.datauvol IS NULL
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_kk
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND mv.removed IS NULL
ORDER BY fio, mv.vac_start