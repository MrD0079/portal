/* Formatted on 28.08.2017 17:33:16 (QP5 v5.252.13127.32867) */
  SELECT s.id,
         s.login,
         s.FAM,
         s.IM,
         s.OTCH,
         TO_CHAR (s.BIRTHDAY, 'dd.mm.yyyy') BIRTHDAY,
         TO_CHAR (s.DATAUVOL, 'dd.mm.yyyy') DATAUVOL,
         TO_CHAR (s.START_company, 'dd.mm.yyyy') START_company,
         s.inn,
         s.passport,
         s.working_hours,
         s.DOLGN,
         s.pos_id,
         s.chief
    FROM spr_users_ms s
   WHERE     (   chief IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_ma, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (   (    login NOT IN (SELECT login
                                      FROM routes_head
                                     WHERE data = TO_DATE ( :month_list, 'dd.mm.yyyy'))
                  AND datauvol IS NULL)
              OR login = :login)
ORDER BY s.fam, s.im, s.otch