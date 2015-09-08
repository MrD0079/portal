/* Formatted on 09/07/2015 17:47:03 (QP5 v5.227.12220.39724) */
SELECT id, TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu, ok_traid
  FROM act_OK
 WHERE tn = :tn AND m = :month AND act = :act