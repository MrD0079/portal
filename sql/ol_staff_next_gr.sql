/* Formatted on 30/10/2014 18:45:25 (QP5 v5.227.12220.39724) */
SELECT u.fio,
       u.e_mail,
       uf.fio staff_fio,
       o.cat
  FROM ol_staff o,
       user_list u,
       free_staff f,
       user_list uf
 WHERE     o.free_staff_id = (SELECT free_staff_id
                                FROM ol_staff
                               WHERE id = :id)
       AND o.gruppa = (SELECT MIN (gruppa)
                         FROM ol_staff
                        WHERE     free_staff_id = (SELECT free_staff_id
                                                     FROM ol_staff
                                                    WHERE id = :id)
                              AND gruppa > (SELECT gruppa
                                              FROM ol_staff
                                             WHERE id = :id))
       AND u.tn = o.tn
       AND o.free_staff_id = f.id
       AND uf.tn = f.tn