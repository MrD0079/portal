/* Formatted on 29/05/2015 12:40:47 (QP5 v5.227.12220.39724) */
  SELECT fio, tn, TO_CHAR (datauvol, 'dd.mm.yyyy') datauvol
    FROM user_list
   WHERE is_db = 1 AND (:actual = 0 OR (:actual = 1 AND datauvol IS NULL))
ORDER BY fio