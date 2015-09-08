/* Formatted on 10.02.2014 9:55:24 (QP5 v5.227.12220.39724) */
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
ORDER BY fio