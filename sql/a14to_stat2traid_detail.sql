/* Formatted on 01/09/2016 20:45:10 (QP5 v5.252.13127.32867) */
  SELECT m1.fio_ts,
         m1.fio_eta,
         m1.tp_ur,
         m1.tp_addr,
         m1.visit_fakt,
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
            ok_st_tmminus,
         mn.summa
    FROM (SELECT fio_ts,
                 fio_eta,
                 tp_ur,
                 tp_addr,
                 visit_fakt,
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
                 tp_kod_key,
                 summa
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
                            WHERE master IN DECODE ( :tn, -1, master, :tn))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND ( :eta_list IS NULL OR :eta_list = m1.h_fio_eta)
         AND m1.tp_kod_key = mn.tp_kod_key(+)
         /* Факт - all TPs with standart */
         AND (   ( :sttype = 'all' AND (mn.sttobytp = 1 OR mn.ok_st_tm = 1))
              /* Достигнут стандарт - show TPs in the list from p.8 */
              OR (    :sttype = 'plus'
                  AND (   CASE
                             WHEN m1.sttobytp IS NULL AND mn.sttobytp = 1
                             THEN
                                1
                          END = 1
                       OR CASE
                             WHEN m1.ok_st_tm IS NULL AND mn.ok_st_tm = 1
                             THEN
                                1
                          END = 1))
              /* Потерян стандарт - show TPs in the list from p.9 */
              OR (    :sttype = 'minus'
                  AND (   CASE
                             WHEN m1.sttobytp = 1 AND mn.sttobytp IS NULL
                             THEN
                                1
                          END = 1
                       OR CASE
                             WHEN m1.ok_st_tm = 1 AND mn.ok_st_tm IS NULL
                             THEN
                                1
                          END = 1)))
ORDER BY m1.fio_ts,
         m1.fio_eta,
         m1.tp_ur,
         m1.tp_addr