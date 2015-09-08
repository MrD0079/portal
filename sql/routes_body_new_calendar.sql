/* Formatted on 16.01.2014 10:01:11 (QP5 v5.227.12220.39724) */
/*  SELECT *
    FROM calendar c
   WHERE TRUNC (c.data, 'mm') = (SELECT data
                                   FROM routes_head
                                  WHERE id = :route)
ORDER BY dm*/



  SELECT distinct dw,dwt
    FROM calendar c
   WHERE TRUNC (c.data, 'mm') = (SELECT data
                                   FROM routes_head
                                  WHERE id = :route)
ORDER BY dw