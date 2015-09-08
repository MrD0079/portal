/* Formatted on 24.04.2013 9:12:05 (QP5 v5.163.1008.3004) */
SELECT DISTINCT akbprev, visible
  FROM w4u_transit1
 WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta