/* Formatted on 17.11.2014 16:42:29 (QP5 v5.227.12220.39724) */
  SELECT u.tn, u.fio, k.*
    FROM user_list u,
         (SELECT *
            FROM kcc
           WHERE dt = TO_DATE (:sd, 'dd.mm.yyyy')) k
   WHERE     u.is_coach = 1
         AND u.tn = k.coach(+)
         AND (u.datauvol IS NULL OR k.coach IS NOT NULL)
         AND u.dpt_id = :dpt_id
ORDER BY u.fio