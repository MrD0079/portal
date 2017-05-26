/* Formatted on 26.05.2017 14:06:41 (QP5 v5.252.13127.32867) */
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
   WHERE     DECODE ( :flt,
                     0, SYSDATE,
                     1, NVL (s.datauvol, SYSDATE),
                     -1, s.datauvol) =
                DECODE ( :flt,  0, SYSDATE,  1, SYSDATE,  -1, s.datauvol)
         AND (   chief IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY s.fam, s.im, s.otch