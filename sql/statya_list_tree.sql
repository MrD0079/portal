/* Formatted on 20.04.2017 17:20:01 (QP5 v5.252.13127.32867) */
           SELECT LEVEL, s.*
             FROM (SELECT -1 id,
                          0 parent,
                          'Конд' cost_item,
                          NULL lu
                     FROM DUAL
                   UNION
                   SELECT -2 id,
                          0 parent,
                          'НГ' cost_item,
                          NULL lu
                     FROM DUAL
                   UNION
                   SELECT -3 id,
                          0 parent,
                          'Кофе' cost_item,
                          NULL lu
                     FROM DUAL
                   UNION
                   SELECT id,
                          DECODE (
                             s.parent,
                             0, CASE
                                   WHEN s.id NOT IN (42, 96882041) THEN -1
                                   WHEN s.id = 42 THEN -2
                                   WHEN s.id = 96882041 THEN -3
                                END,
                             s.parent)
                             parent,
                          cost_item,
                          lu
                     FROM statya s) s
       START WITH PARENT = 0
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY cost_item