/* Formatted on 24.01.2013 9:11:47 (QP5 v5.163.1008.3004) */
SELECT COUNT (*)
  FROM tr_test_qa qa, tr_order_head h
 WHERE h.id = :id AND qa.TYPE = 5 AND h.tr = qa.tr