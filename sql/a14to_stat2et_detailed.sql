/* Formatted on 15.06.2017 09:58:09 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         wm_concat (DISTINCT region_name) region_name,
         fio_eta,
         h_fio_eta key,
         tp_kod_key,
         tp_ur,
         tp_addr,
         tp_place,
         tp_type,
         tp_type_short,
         MAX (stelag) stelag,
         MAX (tumb) tumb,
         SUM (ts1) ts1,
         SUM (ts1r) ts1r,
         AVG (summa) summa,
         COUNT (DISTINCT tp_kod_key || visitdate) visit_plan,
         COUNT (DISTINCT DECODE (visit, 0, NULL, tp_kod_key || visitdate))
            visit_fakt,
           standart_price
         * DECODE (zst_lu, NULL, 0, 1)
         * DECODE (reject_traid_in_month, 1, NULL, 1)
            bonus4tp,
         standart_price,
         zst_lu,
         zst_lu_fio,
         zst_comm,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
         standart,
         reject_traid_in_month,
         a14toGetTarget (tp_kod_key, TO_DATE ( :ed, 'dd.mm.yyyy')) target,
         a14toGetTargetInfo (tp_kod_key, TO_DATE ( :ed, 'dd.mm.yyyy'))
            target_info
    FROM (SELECT z.*,
                 CASE
                    WHEN :by_who = 'eta' THEN standart_price_eta
                    WHEN :by_who = 'ts' THEN standart_price_ts
                 END
                    standart_price
            FROM a14to_mv z
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
                 AND DECODE ( :ok_ts, 1, ok_ts, :ok_ts) = ok_ts
                 AND DECODE ( :ok_auditor, 1, ok_auditor, :ok_auditor) =
                        ok_auditor
                 AND DECODE ( :st_ts, 1, st_ts, :st_ts) = st_ts
                 AND DECODE ( :st_auditor, 1, st_auditor, :st_auditor) =
                        st_auditor
                 AND DECODE ( :ok_st_tm, 1, ok_st_tm, :ok_st_tm) = ok_st_tm
                 AND (   :standart = 1
                      OR ( :standart = 2 AND standart = 'A')
                      OR ( :standart = 3 AND standart = 'B')))
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
         standart_price,
         zst_lu,
         zst_lu_fio,
         zst_comm,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
         standart,
         reject_traid_in_month
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