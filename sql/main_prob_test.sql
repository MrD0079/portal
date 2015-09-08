/* Formatted on 17.11.2014 14:56:41 (QP5 v5.227.12220.39724) */
SELECT pt.*, i.*, ROUND (pt.test_len / 60) test_len_h
  FROM prob_test pt, p_plan i
 WHERE     pt.id = i.test_id
       AND i.test = 1
       AND i.tn = :tn
       AND SYSDATE < i.test_lu + 2