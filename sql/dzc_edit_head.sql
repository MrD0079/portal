/* Formatted on 11/09/2015 12:07:01 (QP5 v5.227.12220.39724) */
SELECT fn_getname (tn) creator,
       (SELECT dpt_id
          FROM user_list
         WHERE tn = dzc.tn)
          dpt_id,
       dzc.*,
       TO_CHAR (dzc.dt, 'dd.mm.yyyy') dt
  FROM dzc
 WHERE id = :id