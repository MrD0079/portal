/* Formatted on 30/10/2014 18:45:39 (QP5 v5.227.12220.39724) */
  SELECT NVL (o.sum_plus, 0) - NVL (o.sum_minus, 0) summa,
         u.fio,
         u.pos_name,
         TO_CHAR (o.accepted_dt, 'dd.mm.yyyy hh24:mi:ss') accepted_dt
    FROM ol_staff o, user_list u
   WHERE     o.free_staff_id = (SELECT free_staff_id
                                  FROM ol_staff
                                 WHERE id = :id)
         AND o.gruppa <= (SELECT gruppa
                            FROM ol_staff
                           WHERE id = :id)
         AND u.tn = o.tn
         AND o.accepted = 1
ORDER BY o.gruppa, u.fio