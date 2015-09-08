/* Formatted on 2011/12/27 09:58 (Formatter Plus v4.8.8) */
SELECT   ver,
         NVL(ok_sdu_rmkk_tmkk, 0) ok_sdu_rmkk_tmkk,
         NVL(ok_sdu_nmkk, 0) ok_sdu_nmkk,
         NVL(ok_sdu_fin_man, 0) ok_sdu_fin_man,
         NVL(ok_sdu_dpu, 0) ok_sdu_dpu,
         TO_CHAR(created, 'dd.mm.yyyy hh24:mi:ss') created
    FROM sdu
   WHERE id_net = :net
     AND YEAR = :YEAR
ORDER BY ver