/* Formatted on 01/09/2016 20:44:15 (QP5 v5.252.13127.32867) */
SELECT COUNT (DISTINCT tp_kod_key) tp_kod_key,
       COUNT (DISTINCT DECODE (sttobytp, NULL, NULL, tp_kod_key)) tpcbytp,
       COUNT (DISTINCT DECODE (ok_st_tm, NULL, NULL, tp_kod_key)) tpcbytm,
         COUNT (DISTINCT DECODE (sttobytp, NULL, NULL, tp_kod_key))
       + COUNT (DISTINCT DECODE (ok_st_tm, NULL, NULL, tp_kod_key))
          tpstc,
       COUNT (DISTINCT DECODE (nsttobytp, NULL, NULL, tp_kod_key)) ntpcbytp,
       COUNT (DISTINCT DECODE (nok_st_tm, NULL, NULL, tp_kod_key)) ntpcbytm,
         COUNT (DISTINCT DECODE (nsttobytp, NULL, NULL, tp_kod_key))
       + COUNT (DISTINCT DECODE (nok_st_tm, NULL, NULL, tp_kod_key))
          ntpstc,
         COUNT (DISTINCT DECODE (nsttobytp, NULL, NULL, tp_kod_key))
       - COUNT (DISTINCT DECODE (sttobytp, NULL, NULL, tp_kod_key))
          prirosttpcbytp,
         COUNT (DISTINCT DECODE (nok_st_tm, NULL, NULL, tp_kod_key))
       - COUNT (DISTINCT DECODE (ok_st_tm, NULL, NULL, tp_kod_key))
          prirosttpcbytm,
         (  COUNT (DISTINCT DECODE (nsttobytp, NULL, NULL, tp_kod_key))
          + COUNT (DISTINCT DECODE (nok_st_tm, NULL, NULL, tp_kod_key)))
       - (  COUNT (DISTINCT DECODE (sttobytp, NULL, NULL, tp_kod_key))
          + COUNT (DISTINCT DECODE (ok_st_tm, NULL, NULL, tp_kod_key)))
          prirosttpstc,
       SUM (visit_fakt) visit_fakt,
       SUM (nvisit_fakt) nvisit_fakt,
       SUM (prirost) prirost,
       SUM (sttobytp) sttobytp,
       SUM (nsttobytp) nsttobytp,
       SUM (sttobytpplus) sttobytpplus,
       SUM (sttobytpminus) sttobytpminus,
       SUM (ok_st_tm) ok_st_tm,
       SUM (nok_st_tm) nok_st_tm,
       SUM (ok_st_tmplus) ok_st_tmplus,
       SUM (ok_st_tmminus) ok_st_tmminus,
       NVL (SUM (sttobytpplus), 0) + NVL (SUM (ok_st_tmplus), 0) stplus,
       NVL (SUM (sttobytpminus), 0) + NVL (SUM (ok_st_tmminus), 0) stminus,
       NULL
  FROM (SELECT m1.visit_fakt,
               m1.sttobytp,
               m1.ok_st_tm,
               m1.tp_kod_key,
               mn.visit_fakt nvisit_fakt,
               NVL (mn.visit_fakt, 0) - NVL (m1.visit_fakt, 0) prirost,
               mn.sttobytp nsttobytp,
               CASE WHEN m1.sttobytp IS NULL AND mn.sttobytp = 1 THEN 1 END
                  sttobytpplus,
               CASE WHEN m1.sttobytp = 1 AND mn.sttobytp IS NULL THEN 1 END
                  sttobytpminus,
               mn.ok_st_tm nok_st_tm,
               CASE WHEN m1.ok_st_tm IS NULL AND mn.ok_st_tm = 1 THEN 1 END
                  ok_st_tmplus,
               CASE WHEN m1.ok_st_tm = 1 AND mn.ok_st_tm IS NULL THEN 1 END
                  ok_st_tmminus
          FROM (SELECT visit_fakt,
                       sttobytp,
                       ok_st_tm,
                       tp_kod_key,
                       h_fio_eta,
                       tn
                  FROM a14to_mv_st
                 WHERE     period = TO_DATE ( :sd, 'dd.mm.yyyy')
                       AND dpt_id = :dpt_id
                       AND (   :standart = 1
                            OR ( :standart = 2 AND standart = 'A')
                            OR ( :standart = 3 AND standart = 'B'))) m1,
               (SELECT visit_fakt,
                       sttobytp,
                       ok_st_tm,
                       tp_kod_key
                  FROM a14to_mv_st
                 WHERE     period = TO_DATE ( :ed, 'dd.mm.yyyy')
                       AND dpt_id = :dpt_id
                       AND (   :standart = 1
                            OR ( :standart = 2 AND standart = 'A')
                            OR ( :standart = 3 AND standart = 'B'))) mn
         WHERE     (   :exp_list_without_ts = 0
                    OR m1.tn IN (SELECT slave
                                   FROM full
                                  WHERE master = :exp_list_without_ts))
               AND (   :exp_list_only_ts = 0
                    OR m1.tn IN (SELECT slave
                                   FROM full
                                  WHERE master = :exp_list_only_ts))
               AND (   m1.tn IN (SELECT slave
                                   FROM full
                                  WHERE master IN DECODE ( :tn,
                                                          -1, master,
                                                          :tn))
                    OR (SELECT NVL (is_admin, 0)
                          FROM user_list
                         WHERE tn = :tn) = 1
                    OR (SELECT NVL (is_kpr, 0)
                          FROM user_list
                         WHERE tn = :tn) = 1)
               AND ( :eta_list IS NULL OR :eta_list = m1.h_fio_eta)
               AND m1.tp_kod_key = mn.tp_kod_key(+))