/* Formatted on 25.10.2013 9:45:58 (QP5 v5.227.12220.39724) */
SELECT h.id,
       TO_CHAR (h.dt, 'dd.mm.yyyy') dt,
       h.fil,db
  FROM bud_ru_cash_out_head h
 WHERE h.id = :id