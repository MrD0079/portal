/* Formatted on 2010/12/06 15:40 (Formatter Plus v4.8.8) */
SELECT   ROWNUM,
         z.*,
         (SELECT pos_name
            FROM pos
           WHERE pos_id = z.pos) pos_name,
         CASE
            WHEN TYPE = 6
            AND weight = 0
               THEN 'нет'
            WHEN TYPE = 6
            AND weight = 1
               THEN 'да'
         END ans,
         CASE
            WHEN TYPE = 6
            AND weight = 0
               THEN 0
            WHEN TYPE = 6
            AND weight = 1
               THEN 1
         END ans_val
    FROM ocenka_criteria z
   WHERE event = ?
     AND TYPE = ?
     AND NVL(PARENT, 0) = ?
ORDER BY pos_name,
         num