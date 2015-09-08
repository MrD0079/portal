/* Formatted on 20.01.2015 13:00:43 (QP5 v5.227.12220.39724) */
SELECT fund_id, TO_CHAR (dtz, 'dd.mm.yyyy') dtz
  FROM BUD_ACT_FUND
 WHERE act = :act AND TO_NUMBER (TO_CHAR (act_month, 'mm')) = :m