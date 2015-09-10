/* Formatted on 15.07.2014 11:24:24 (QP5 v5.227.12220.39724) */
SELECT TO_CHAR (ac.created, 'dd.mm.yyyy hh24:mi:ss') created,
       TO_CHAR (ac.dt, 'dd.mm.yyyy') dt,
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
       ac.vac3,
       p1.pos_name vac1_pos,
       p2.pos_name vac2_pos,
       p3.pos_name vac3_pos,
       ok_accept_tn
  FROM ac,
       user_list u,
       user_list u1,
       pos p1,
       pos p2,
       pos p3
 WHERE     ac.id = :id
       AND ac.tn = u.tn
       AND ac.init_tn = u1.tn
       AND ac.vac1_pos = p1.pos_id(+)
       AND ac.vac2_pos = p2.pos_id(+)
       AND ac.vac3_pos = p3.pos_id(+)