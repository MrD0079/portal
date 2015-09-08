/* Formatted on 27/05/2015 18:59:52 (QP5 v5.227.12220.39724) */
SELECT c.mt || ' ' || c.y dt, TO_CHAR (c.data, 'dd.mm.yyyy') data
  FROM advance_ok o, calendar c
 WHERE NVL (o.ok_ndp, 0) = 1 AND NVL (o.ok_dpu, 0) <> 1 AND c.data = o.m