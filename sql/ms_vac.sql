/* Formatted on 26.05.2017 18:13:52 (QP5 v5.252.13127.32867) */
  SELECT s.id,
         s.login,
         s.FAM || ' ' || s.IM || ' ' || s.OTCH fio,
         TO_CHAR (s.BIRTHDAY, 'dd.mm.yyyy') BIRTHDAY,
         TO_CHAR (s.DATAUVOL, 'dd.mm.yyyy') DATAUVOL,
         TO_CHAR (s.START_company, 'dd.mm.yyyy') START_company,
         TRUNC (SYSDATE) - s.START_company experience,
         /*ADD_MONTHS (TRUNC (SYSDATE), -12) z,
         (SELECT COUNT (DISTINCT y || '.' || my)
            FROM calendar
           WHERE data BETWEEN s.START_company AND TRUNC (SYSDATE))
            mmm,*/
         s.inn,
         s.passport,
         s.working_hours,
         s.DOLGN,
         s.pos_id,
         s.chief
    FROM spr_users_ms s
   WHERE     /*s.datauvol IS NULL
         AND */
         (      chief IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
             OR (SELECT NVL (is_admin, 0)
                   FROM user_list
                  WHERE tn = :tn) = 1)
         AND s.START_company IS NOT NULL
ORDER BY fio