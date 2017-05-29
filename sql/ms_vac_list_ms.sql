/* Formatted on 29.05.2017 16:52:17 (QP5 v5.252.13127.32867) */
  SELECT s.id,
         s.login,
         s.FAM || ' ' || s.IM || ' ' || s.OTCH fio,
         TO_CHAR (s.BIRTHDAY, 'dd.mm.yyyy') BIRTHDAY,
         TO_CHAR (s.DATAUVOL, 'dd.mm.yyyy') DATAUVOL,
         TO_CHAR (s.START_company, 'dd.mm.yyyy') START_company,
         TRUNC (SYSDATE) - s.START_company experience_days,
         TRUNC ( (TRUNC (SYSDATE) - s.START_company) / 365) experience_y,
         TRUNC (
              (  (TRUNC (SYSDATE) - s.START_company)
               - TRUNC ( (TRUNC (SYSDATE) - s.START_company) / 365) * 365)
            / 30.4)
            experience_m,
         TRUNC (
              (TRUNC (SYSDATE) - s.START_company)
            - TRUNC ( (TRUNC (SYSDATE) - s.START_company) / 365) * 365
            -   TRUNC (
                     (  (TRUNC (SYSDATE) - s.START_company)
                      -   TRUNC ( (TRUNC (SYSDATE) - s.START_company) / 365)
                        * 365)
                   / 30.4)
              * 30.4)
            experience_d,
         DECODE (
            SIGN (ADD_MONTHS (TRUNC (SYSDATE), -12) - s.START_company + 1),
            1,   14
               - NVL (
                    (SELECT SUM (days)
                       FROM ms_vac
                      WHERE     login = s.login
                            AND TRUNC (vac_start, 'yyyy') =
                                   TRUNC (SYSDATE, 'yyyy')
                            AND removed IS NULL),
                    0),
            0)
            vac_days_available,
         s.inn,
         s.passport,
         s.working_hours,
         s.DOLGN,
         s.pos_id,
         s.chief,
         (SELECT wm_concat (
                       'с '
                    || TO_CHAR (vac_start, 'dd.mm.yyyy')
                    || ' по '
                    || TO_CHAR (vac_start + days - 1, 'dd.mm.yyyy'))
            FROM (  SELECT *
                      FROM ms_vac
                  ORDER BY vac_start)
           WHERE     login = s.login
                 AND TRUNC (vac_start, 'yyyy') = TRUNC (SYSDATE, 'yyyy')
                 AND removed IS NULL)
            vac_log
    FROM spr_users_ms s,
         user_list u,
         parents p,
         user_list UP
   WHERE     s.chief = u.tn
         AND u.tn = p.tn
         AND p.parent = UP.tn(+)
         AND UP.pos_id(+) = 9214311
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
         AND ( :rm_tn = 0 OR :rm_tn = UP.tn)
         AND ( :svms_tn = 0 OR :svms_tn = u.tn)
ORDER BY fio