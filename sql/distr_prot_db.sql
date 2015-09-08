/* Formatted on 20.06.2014 12:41:56 (QP5 v5.227.12220.39724) */
  SELECT tn, fio
    FROM user_list
   WHERE     is_db = 1
         AND dpt_id = :dpt_id
         AND datauvol IS NULL
         AND (   tn IN (SELECT slave
                          FROM full
                         WHERE master IN
                                     (SELECT parent
                                         FROM assist
                                        WHERE child = :tn AND dpt_id = :dpt_id
                                       UNION
                                       SELECT :tn FROM DUAL))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY fio