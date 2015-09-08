/* Formatted on 13.03.2012 11:11:27 (QP5 v5.163.1008.3004) */
  SELECT s.*, fn_getname ( s.tn) name
    FROM svms_oblast s, user_list u
   WHERE s.tn = u.tn AND u.dpt_id = :dpt_id
ORDER BY oblast, name