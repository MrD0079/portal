/* Formatted on 09/07/2015 17:47:34 (QP5 v5.227.12220.39724) */
SELECT DECODE (lu, NULL, 0, 1)
  FROM act_OK
 WHERE     tn = (SELECT parent
                   FROM parents
                  WHERE tn = :tn)
       AND m = :month
       AND act = :act