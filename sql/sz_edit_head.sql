/* Formatted on 18.09.2012 16:51:48 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) creator,
       (SELECT dpt_id
          FROM user_list
         WHERE tn = sz.tn)
          dpt_id,
       sz.*
  FROM sz
 WHERE id = :id