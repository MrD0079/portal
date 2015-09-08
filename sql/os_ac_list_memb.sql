/* Formatted on 29.04.2014 16:56:04 (QP5 v5.227.12220.39724) */
SELECT i.id,
       u.fio,
       u.e_mail mail,
       i.memb_int_order sort,
       'int' ie,
       'внутренний' iet,
       i.ac_id,
       NULL resume
  FROM ac_memb_int i, user_list u
 WHERE i.ac_id = :id AND u.tn = i.tn
UNION
SELECT i.id,
       i.fam || ' ' || i.im || ' ' || i.otch fio,
       i.email mail,
       i.memb_ext_order sort,
       'ext' ie,
       'внешний' iet,
       i.ac_id,
       i.resume
  FROM ac_memb_ext i
 WHERE i.ac_id = :id
ORDER BY fio