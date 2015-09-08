/* Formatted on 12.03.2013 10:26:59 (QP5 v5.163.1008.3004) */
SELECT TO_CHAR (MAX (bm), 'dd.mm.yyyy') bm, TO_CHAR (MAX (bm), 'mm') m, TO_CHAR (MAX (bm), 'yyyy') y
  FROM w4u_vp
 WHERE m = TO_DATE (:dt, 'dd.mm.yyyy')