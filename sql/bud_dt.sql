/* Formatted on 21.01.2015 16:55:16 (QP5 v5.227.12220.39724) */
  SELECT mt || ' ' || y my,
         TO_CHAR (DATA, 'dd.mm.yyyy') sd_c,
         TO_CHAR (DATA, 'dd.mm.yyyy') ed_c,
         DECODE (ADD_MONTHS (TRUNC (TRUNC (SYSDATE, 'mm'), 'mm'), -1) - data,
                 0, 1,
                 0)
            selected
    FROM calendar c
   WHERE     data = TRUNC (data, 'mm')
         AND (   TRUNC (SYSDATE, 'mm') BETWEEN ADD_MONTHS (TRUNC (data, 'mm'),
                                                           -1)
                                           AND ADD_MONTHS (TRUNC (data, 'mm'),
                                                           3)
              /*OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1*/)
ORDER BY data