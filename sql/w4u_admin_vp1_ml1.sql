/* Formatted on 11.03.2013 12:21:44 (QP5 v5.163.1008.3004) */
  SELECT mt || ' ' || y my, to_char(data,'dd.mm.yyyy') dt
    FROM calendar c
   WHERE TRUNC (data, 'mm') = data AND data BETWEEN to_date('01.04.2013','dd.mm.yyyy') AND to_date('01.12.2013','dd.mm.yyyy')
ORDER BY DATA