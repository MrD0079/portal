/* Formatted on 06.11.2014 16:00:27 (QP5 v5.227.12220.39724) */
SELECT u.dpt_name,
       TO_CHAR (dzc.created, 'dd.mm.yyyy hh24:mi:ss') created,
       dzc.comm,
       dzc.id,
       dzc.cat,
       fn_getname ( dzc.tn) creator,
       DECODE (  (SELECT COUNT (*)
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id)
               - (SELECT COUNT (*)
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id AND accepted = 1),
               0, 1,
               0)
          dzc_ok,
       u.pos_name creator_pos_name,
       u.department_name creator_department_name
  FROM dzc, user_list u
 WHERE     dzc.id = (SELECT dzc_id
                      FROM dzc_accept
                     WHERE id = :accept_id)
       AND dzc.tn = u.tn