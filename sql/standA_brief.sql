/* Brief */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tp_kod_key,
         region_name,
         fio_eta,
         h_fio_eta,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
         COUNT (DISTINCT visitdate) visitdate,
         SUM (urls) urls,
         SUM (cto) cto,
         zst_lu,
         SUM (visit) visit,
         SUM (VALUE) VALUE,
         SUM (summa) summa,
         SUM (ts1r) ts1r,
         CASE
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А'
            THEN
               'Стандарт А'
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) IN ('Стандарт А (минимум)',
                                                                    'Стандарт А,Стандарт А (минимум)')
            THEN
               'Стандарт А (минимум)'
         END
            standart_tp,
         SUM(standA) standA,
         SUM(standAmin) standAmin
    FROM (  SELECT fio_rm,
                   tn_rm,
                   fio_tm,
                   tn_tm,
                   fio_ts,
                   tn,
                   tp_kod_key,
                   region_name,
                   fio_eta,
                   h_fio_eta,
                   eta_tab_number,
                   tab_num_ts,
                   tab_num_tm,
                   tab_num_rm,
                   visitdate,
                   SUM (urls) urls,
                   SUM (cto) cto,
                   zst_lu,
                   visit,
                   VALUE,
                   summa,
                   SUM (ts1r) ts1r,
                   CASE
                      WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                              'Стандарт А'
                      THEN
                         'Стандарт А'
                      WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) IN ('Стандарт А (минимум)',
                                                                              'Стандарт А,Стандарт А (минимум)')
                      THEN
                         'Стандарт А (минимум)'
                   END
                      standart_tp,
                   SUM(standA) standA,
                   SUM(standAmin) standAmin
              FROM (
                    select * from (
                          SELECT z.*,
                                CASE
                                    WHEN NVL (standart_tp, 'null') = 'Стандарт А'
                                    THEN
                                       1
                                    ELSE
                                       0
                                 END
                                    standA,
                                CASE
                                    WHEN  NVL (standart_tp, 'null') = 'Стандарт А (минимум)'
                                    THEN
                                       1
                                    ELSE
                                       0
                                 END
                                    standAmin
                            FROM a18to_mv z
                           WHERE     visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                                 AND (   :exp_list_without_ts = 0
                                      OR tn IN (SELECT slave
                                                  FROM FULL
                                                 WHERE MASTER = :exp_list_without_ts))
                                 AND (   :exp_list_only_ts = 0
                                      OR tn IN (SELECT slave
                                                  FROM FULL
                                                 WHERE MASTER = :exp_list_only_ts))
                                 AND (   tn IN (SELECT slave
                                                  FROM FULL
                                                 WHERE MASTER IN (SELECT PARENT
                                                                    FROM assist
                                                                   WHERE     CHILD = :tn
                                                                         AND dpt_id =
                                                                                :dpt_id
                                                                  UNION
                                                                  SELECT DECODE (
                                                                            :tn,
                                                                            -1, master,
                                                                            :tn)
                                                                    FROM DUAL))
                                      OR (SELECT NVL (is_admin, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1
                                      OR (SELECT NVL (is_traid, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1
                                      OR (SELECT NVL (is_traid_kk, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1
                                      OR (SELECT NVL (is_kpr, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1)
                                 AND dpt_id = :dpt_id
                                 AND ( :eta_list IS NULL OR :eta_list = h_fio_eta)
                                 AND ts1 = 1
                     ) t
                     /* select TP by last visitdate*/
                    where t.visitdate = (
                      select max(t1.visitdate)
                      from (
                      SELECT z.visitdate, z.tp_kod_key
                      FROM a18to_mv z
                           WHERE     visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                                 AND (   :exp_list_without_ts = 0
                                      OR tn IN (SELECT slave
                                                  FROM FULL
                                                 WHERE MASTER = :exp_list_without_ts))
                                 AND (   :exp_list_only_ts = 0
                                      OR tn IN (SELECT slave
                                                  FROM FULL
                                                 WHERE MASTER = :exp_list_only_ts))
                                 AND (   tn IN (SELECT slave
                                                  FROM FULL
                                                 WHERE MASTER IN (SELECT PARENT
                                                                    FROM assist
                                                                   WHERE     CHILD = :tn
                                                                         AND dpt_id =
                                                                                :dpt_id
                                                                  UNION
                                                                  SELECT DECODE (
                                                                            :tn,
                                                                            -1, master,
                                                                            :tn)
                                                                    FROM DUAL))
                                      OR (SELECT NVL (is_admin, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1
                                      OR (SELECT NVL (is_traid, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1
                                      OR (SELECT NVL (is_traid_kk, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1
                                      OR (SELECT NVL (is_kpr, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1)
                                 AND dpt_id = :dpt_id
                                 AND ( :eta_list IS NULL OR :eta_list = h_fio_eta)
                                AND ts1 = 1
                       ) t1
                    where t1.tp_kod_key = t.tp_kod_key
                    )
                   )
          GROUP BY fio_rm,
                   tn_rm,
                   fio_tm,
                   tn_tm,
                   fio_ts,
                   tn,
                   tp_kod_key,
                   region_name,
                   fio_eta,
                   h_fio_eta,
                   eta_tab_number,
                   tab_num_ts,
                   tab_num_tm,
                   tab_num_rm,
                   visitdate,
                   zst_lu,
                   visit,
                   VALUE,
                   summa
            HAVING (   :zst = 1
                    OR (    :zst = 2
                        AND CASE
                               WHEN wm_concat (
                                       DISTINCT NVL (standart_tp, 'null')) =
                                       'Стандарт А'
                               THEN
                                  'Стандарт А'
                               WHEN wm_concat (
                                       DISTINCT NVL (standart_tp, 'null')) IN ('Стандарт А (минимум)',
                                                                               'Стандарт А,Стандарт А (минимум)')
                               THEN
                                  'Стандарт А (минимум)'
                            END
                               IS NOT NULL)))
GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tp_kod_key,
         region_name,
         fio_eta,
         h_fio_eta,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
         zst_lu