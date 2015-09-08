/* Formatted on 29.11.2013 10:24:14 (QP5 v5.227.12220.39724) */
SELECT h.id,
       TO_CHAR (h.dt, 'dd.mm.yyyy') dt,
       h.fil,
       h.ok_fil,
       h.ok_fil_text,
       TO_CHAR (h.ok_fil_lu, 'dd.mm.yyyy hh24:mi:ss') ok_fil_lu,db
  FROM bud_ru_cash_in_head h
 WHERE h.id = :id