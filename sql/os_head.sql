/* Formatted on 24.05.2012 14:11:02 (QP5 v5.163.1008.3004) */
SELECT z.*, TO_CHAR (data, 'dd.mm.yyyy') data_t
  FROM os_head z
 WHERE tn = :tn AND y = :y