/* Formatted on 29.04.2014 13:10:02 (QP5 v5.227.12220.39724) */
SELECT TO_CHAR (ac.created, 'dd.mm.yyyy hh24:mi:ss') created,
       ac.head,
       ac.place,
       ac.id,
       DECODE (  (SELECT COUNT (*)
                    FROM ac_accept
                   WHERE ac_id = ac.id)
               - (SELECT COUNT (*)
                    FROM ac_accept
                   WHERE ac_id = ac.id AND accepted = 1),
               0, 1,
               0)
          ac_ok,
       u.fio creator,
       u.pos_name creator_pos_name,
       u.department_name creator_department_name,
       u1.fio init,
       u1.pos_name init_pos_name,
       u1.department_name init_department_name,
       u1.e_mail init_mail,
       ac.vac1,
       ac.vac2,
       ac.vac3
  FROM ac, user_list u, user_list u1
 WHERE ac.id = :id AND ac.tn = u.tn AND ac.init_tn = u1.tn