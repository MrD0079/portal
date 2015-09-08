/* Formatted on 09/12/2014 21:40:49 (QP5 v5.227.12220.39724) */
  SELECT s.*, fn_getname ( s.tn) name
    FROM mkk_oblast s, user_list u
   WHERE s.tn = u.tn AND u.dpt_id = :dpt_id
ORDER BY oblast, name