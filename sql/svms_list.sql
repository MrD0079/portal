/* Formatted on 05/12/2014 12:32:22 (QP5 v5.227.12220.39724) */
  SELECT tn, fio
    FROM user_list
   WHERE     pos_id = 69
         AND dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND (   tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn
 UNION
                        SELECT chief
                          FROM spr_users_ms
                         WHERE     login = :login
                               AND (SELECT is_smr
                                      FROM user_list
                                     WHERE login = :login) = 1)
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1

              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1

              OR (SELECT is_kk
                    FROM user_list
                   WHERE tn = :tn) = 1

)
ORDER BY fio