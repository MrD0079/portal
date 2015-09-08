SELECT ec.*,
       CASE WHEN ec.tn = ec.exp_tn THEN 1 END is_self,
       CASE
          WHEN ec.exp_tn = (SELECT parent
                              FROM parents
                             WHERE tn = ec.tn)
          THEN
             1
       END
          is_chief,
       u.fio
  FROM ocenka_exp_comment ec, user_list u
 WHERE ec.tn = :tn AND ec.event = :event AND ec.exp_tn = u.tn