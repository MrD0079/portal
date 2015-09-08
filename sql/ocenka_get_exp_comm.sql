/* Formatted on 15.01.2013 11:08:29 (QP5 v5.163.1008.3004) */
SELECT ROWNUM, fn_getname ( exp_tn) exp_name, ec.comm
  FROM ocenka_exp_comment ec
 WHERE tn = :tn AND tn <> exp_tn AND event = :event