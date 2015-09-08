/* Formatted on 26.12.2013 13:37:57 (QP5 v5.227.12220.39724) */
SELECT TO_CHAR (bud_ru_zay.created, 'dd.mm.yyyy hh24:mi:ss') created,
       bud_ru_zay.id,
       fn_getname ( bud_ru_zay.tn) creator,
       DECODE (  (SELECT COUNT (*)
                    FROM bud_ru_zay_accept
                   WHERE z_id = bud_ru_zay.id)
               - (SELECT COUNT (*)
                    FROM bud_ru_zay_accept
                   WHERE z_id = bud_ru_zay.id AND accepted = 464261),
               0, 1,
               0)
          bud_ru_zay_ok,
       DECODE (  (SELECT COUNT (*)
                    FROM bud_ru_zay_accept
                   WHERE z_id = bud_ru_zay.id and rep_accepted is not null)
               - (SELECT COUNT (*)
                    FROM bud_ru_zay_accept
                   WHERE z_id = bud_ru_zay.id and rep_accepted is not null AND rep_accepted = 464261),
               0, 1,
               0)
          rep_bud_ru_zay_ok,
       u.pos_name creator_pos_name,
       u.department_name creator_department_name
  FROM bud_ru_zay, user_list u
 WHERE     bud_ru_zay.id = (SELECT z_id
                              FROM bud_ru_zay_accept
                             WHERE id = :accept_id)
       AND bud_ru_zay.tn = u.tn