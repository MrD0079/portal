/* Formatted on 06.11.2014 16:00:27 (QP5 v5.227.12220.39724) */
SELECT u.dpt_name,
       TO_CHAR (sz.created, 'dd.mm.yyyy hh24:mi:ss') created,
       sz.head,
       sz.body,
       sz.id,
       sz.cat,
       fn_getname ( sz.tn) creator,
       DECODE (  (SELECT COUNT (*)
                    FROM sz_accept
                   WHERE sz_id = sz.id)
               - (SELECT COUNT (*)
                    FROM sz_accept
                   WHERE sz_id = sz.id AND accepted = 1),
               0, 1,
               0)
          sz_ok,
       u.pos_name creator_pos_name,
       u.department_name creator_department_name
  FROM sz, user_list u
 WHERE     sz.id = (SELECT sz_id
                      FROM sz_accept
                     WHERE id = :accept_id)
       AND sz.tn = u.tn