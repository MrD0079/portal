/* Formatted on 14.07.2014 15:50:24 (QP5 v5.227.12220.39724) */
SELECT z.*, ac.ok_accept_tn
  FROM (SELECT i.id,
               u.fio,
               u.e_mail mail,
               i.memb_int_order sort,
               'int' ie,
               'внутренний' iet,
               i.ac_id,
               NULL resume
          FROM ac_memb_int i, user_list u
         WHERE u.tn = i.tn
        UNION
        SELECT i.id,
               i.fam || ' ' || i.im || ' ' || i.otch fio,
               i.email mail,
               i.memb_ext_order sort,
               'ext' ie,
               'внешний' iet,
               i.ac_id,
               i.resume
          FROM ac_memb_ext i) z,
       ac
 WHERE z.id = :ac_memb_id AND z.ac_id = ac.id