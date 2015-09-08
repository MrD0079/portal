/* Formatted on 23.10.2013 10:14:38 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
         u.fio chater,
         c.text,
         u.department_name,
         u.pos_name
    FROM bud_ru_zay_chat c, user_list u
   WHERE c.z_id = :id AND c.tn = u.tn
ORDER BY lu