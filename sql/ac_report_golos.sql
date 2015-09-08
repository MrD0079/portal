/* Formatted on 14.07.2014 14:43:12 (QP5 v5.227.12220.39724) */
SELECT t1.*, t2.name res_name
  FROM ac_golos t1, ac_golos_res t2
 WHERE t1.ac_id = :id AND t1.res_id = t2.id