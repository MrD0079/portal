/* Formatted on 15.07.2013 11:51:37 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
         u.fio chater,
         c.text,
         u.department_name,
         u.pos_name
    FROM sz_chat c, user_list u
   WHERE c.sz_id = :id AND c.tn = u.tn
ORDER BY lu