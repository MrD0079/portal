/* Formatted on 17.04.2012 12:58:17 (QP5 v5.163.1008.3004) */
  SELECT c.id,
         c.name,
         c.dog_num,
         TO_CHAR (c.dog_start, 'dd.mm.yyyy') dog_start,
         TO_CHAR (c.dog_end, 'dd.mm.yyyy') dog_end,
         S.id_net
    FROM urlic c,
         (SELECT *
            FROM urlic_net
           WHERE id_net = :id_net) s
   WHERE c.id = s.urlic(+)
ORDER BY c.name