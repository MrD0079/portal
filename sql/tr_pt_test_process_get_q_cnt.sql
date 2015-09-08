/* Formatted on 16.09.2013 15:15:59 (QP5 v5.227.12220.39724) */
SELECT COUNT (*)
  FROM tr_test_qa qa, tr_pt_order_head h
 WHERE h.id = :id AND qa.TYPE = 5 AND h.tr = qa.tr