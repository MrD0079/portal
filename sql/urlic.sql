/* Formatted on 17.04.2012 12:11:50 (QP5 v5.163.1008.3004) */
  SELECT u.id,
         u.name,
         u.dog_num,
         TO_CHAR (u.dog_start, 'dd.mm.yyyy') dog_start,
         TO_CHAR (u.dog_end, 'dd.mm.yyyy') dog_end
    FROM urlic u
ORDER BY name