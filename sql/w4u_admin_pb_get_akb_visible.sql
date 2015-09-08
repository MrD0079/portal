/* Formatted on 29.03.2013 16:03:36 (QP5 v5.163.1008.3004) */
SELECT DISTINCT akb, visible
  FROM w4u_transit
 WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta