/* Formatted on 2011/11/30 11:46 (Formatter Plus v4.8.8) */
SELECT     LEVEL,
           s.*
      FROM statya s
START WITH PARENT = 0
CONNECT BY PRIOR ID = PARENT
  ORDER SIBLINGS BY cost_item