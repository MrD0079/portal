/* Formatted on 18.09.2012 16:51:48 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) creator,
       (SELECT dpt_id
          FROM user_list
         WHERE tn = dzc.tn)
          dpt_id,
       dzc.*
  FROM dzc
 WHERE id = :id