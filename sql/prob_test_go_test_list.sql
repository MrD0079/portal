/* Formatted on 17.11.2014 12:38:48 (QP5 v5.227.12220.39724) */
SELECT pt.*, i.*, ROUND (pt.test_len / 60) test_len_h
  FROM prob_test pt, p_plan i
 WHERE pt.id = i.test_id AND i.tn = :tn