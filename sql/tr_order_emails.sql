/* Formatted on 13/09/2013 14:26:57 (QP5 v5.227.12220.39724) */
SELECT e_mail
  FROM user_list
 WHERE (pos_id = 63 OR tn = :tn) /*AND dpt_id = :dpt_id */AND datauvol IS NULL