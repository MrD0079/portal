/* Formatted on 20.04.2017 17:41:08 (QP5 v5.252.13127.32867) */
           SELECT LEVEL,
                  s.*,
                  CASE
                     WHEN DECODE (s.parent, 0, s.id, s.parent) NOT IN (42, 96882041)
                     THEN
                        '����'
                     WHEN DECODE (s.parent, 0, s.id, s.parent) = 42
                     THEN
                        '��'
                     WHEN DECODE (s.parent, 0, s.id, s.parent) = 96882041
                     THEN
                        '����'
                  END
                     kat
             FROM statya s
       START WITH PARENT = 0
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY cost_item