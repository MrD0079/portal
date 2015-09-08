/* Formatted on 17.11.2014 13:01:33 (QP5 v5.227.12220.39724) */
SELECT COUNT (*)
  FROM prob_test qa
 WHERE qa.parent = (SELECT test_id
                      FROM p_plan
                     WHERE tn = :tn)