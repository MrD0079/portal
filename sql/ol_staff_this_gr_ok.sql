/* Formatted on 10.01.2014 14:45:49 (QP5 v5.227.12220.39724) */
SELECT DECODE (NVL (COUNT (*) - SUM (NVL (accepted, 0)), 0), 0, 1, 0)
          this_gr_ok
  FROM ol_staff
 WHERE     free_staff_id = (SELECT free_staff_id
                              FROM ol_staff
                             WHERE id = :id)
       AND gruppa = (SELECT gruppa
                       FROM ol_staff
                      WHERE id = :id)