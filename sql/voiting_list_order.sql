/* Formatted on 11/04/2016 18:02:05 (QP5 v5.252.13127.32867) */
SELECT tr.id,
       tr.name,
       tr.test_len,
       ROUND (tr.test_len / 60) test_len_h,
       DECODE (oo.tn, NULL, NULL, 1) test_enabled
  FROM tr, voiting_test_onoff oo
 WHERE tr.id = :id AND tr.id = oo.tr(+) AND :tn = oo.tn(+)