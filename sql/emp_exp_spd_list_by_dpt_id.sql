/* Formatted on 10/10/2014 12:45:15 (QP5 v5.227.12220.39724) */
  SELECT u.fio,
         u.tn,
         TO_CHAR (u.datauvol, 'dd.mm.yyyy') datauvol,
         u.pos_name
    FROM user_list u
   WHERE     u.is_spd = 1
         AND u.dpt_id = :dpt_id
         AND (:actual = 0 OR :actual = 1 AND datauvol IS NULL)
ORDER BY u.fio