/* Formatted on 13/07/2015 18:13:34 (QP5 v5.227.12220.39724) */
  SELECT tn, fio
    FROM user_list
   WHERE     tn IN (SELECT tn
                      FROM parents
                     WHERE parent = :tn
                    UNION
                    SELECT tn
                      FROM parents
                     WHERE parent IN (SELECT tn
                                        FROM parents
                                       WHERE parent = :tn))
         AND datauvol IS NULL
         AND is_spd = 1
ORDER BY fio