/* Formatted on 04.07.2012 9:26:41 (QP5 v5.163.1008.3004) */
  SELECT c.y year, z.*, TO_CHAR (data, 'dd.mm.yyyy') data_t
    FROM (SELECT *
            FROM os_head
           WHERE tn = :tn) z,
         (SELECT DISTINCT y
            FROM calendar
           WHERE y BETWEEN :y - 2 AND :y) c
   WHERE z.y(+) = c.y
ORDER BY c.y DESC