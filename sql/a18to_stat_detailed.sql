/* Formatted on 10.08.2018 01:53:21 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         fio_eta,
         h_fio_eta key,
         tp_kod_key,
         tp_ur,
         tp_addr,
         tp_place,
         tp_type,
         tp_type_short,
         zst_lu,
         zst_lu_fio,
         zst_comm,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
         wm_concat (DISTINCT region_name) region_name,
         SUM (cto) cto,
         /*SUM (ts1) ts1,*/
         SUM (ts1r) ts1r,
         AVG (summa) summa,
         COUNT (DISTINCT tp_kod_key || visitdate) visit_plan,
         COUNT (DISTINCT DECODE (visit, 0, NULL, tp_kod_key || visitdate))
            visit_fakt,
         CASE
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А'
            THEN
               60
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А (минимум)'
            THEN
               10
         END
            /* * DECODE (zst_lu, NULL, 0, 1)*/
            /** DECODE (reject_traid_in_month, 1, NULL, 1)*/
            bonus4tp,
         /*--type_standart_price,*/
         /*,
                  type_standart,*/

         CASE
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А'
            THEN
               'Стандарт А'
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А (минимум)'
            THEN
               'Стандарт А (минимум)'
         END
            standart_tp,
         CASE
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А'
            THEN
               60
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А (минимум)'
            THEN
               10
         END
            standart_price,
         /*standart_price,*/
         /*reject_traid_in_month,*/
         a18toGetTarget (tp_kod_key, TO_DATE ( :ed, 'dd.mm.yyyy')) target,
         a18toGetTargetInfo (tp_kod_key, TO_DATE ( :ed, 'dd.mm.yyyy'))
            target_info
    FROM (SELECT z.* 
            FROM a18to_mv z
           WHERE     visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND (   :exp_list_without_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                 AND (   tn IN (SELECT slave
                                  FROM full
                                 WHERE master IN (SELECT parent
                                                    FROM assist
                                                   WHERE     child = :tn
                                                         AND dpt_id = :dpt_id
                                                  UNION
                                                  SELECT DECODE ( :tn,
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
                 /*AND DECODE ( :ok_ts, 1, ok_ts, :ok_ts) = ok_ts
                 AND DECODE ( :ok_auditor, 1, ok_auditor, :ok_auditor) =
                        ok_auditor
                 AND DECODE ( :st_ts, 1, st_ts, :st_ts) = st_ts
                 AND DECODE ( :st_auditor, 1, st_auditor, :st_auditor) =
                        st_auditor
                 AND DECODE ( :ok_st_tm, 1, ok_st_tm, :ok_st_tm) = ok_st_tm*/
                 /*AND (   :zst = 1
                      OR ( :zst = 2 AND DECODE (zst_lu, NULL, 0, 1) = 1))*/
                      
                      )
GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         fio_eta,
         h_fio_eta,
         tp_kod_key,
         tp_ur,
         tp_addr,
         tp_place,
         tp_type,
         tp_type_short,
         zst_lu,
         zst_lu_fio,
         zst_comm,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm /*,
          standart_price*/
                /*,
reject_traid_in_month*/

  HAVING (   :zst = 1
          OR (    :zst = 2
              AND CASE
                     WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                             'Стандарт А'
                     THEN
                        'Стандарт А'
                     WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                             'Стандарт А (минимум)'
                     THEN
                        'Стандарт А (минимум)'
                  END
                     IS NOT NULL))
ORDER BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         fio_eta,
         tp_ur,
         tp_addr,
         tp_place,
         tp_type