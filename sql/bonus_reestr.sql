/* Formatted on 13.01.2018 18:10:27 (QP5 v5.252.13127.32867) */
  SELECT h.*,
         TO_CHAR (h.created, 'dd.mm.yyyy hh24:mi:ss') created,
         b.*,
         c.mt,
         c.y,
         bt.name bt_name,
         bst.name bst_name,
         bt.koef,
         bt.koef * b.summa summa_val,
         get_sz_current_status (h.sz_id) sz_status_id,
         get_sz_current_status_lu (h.sz_id) sz_accepted,
         DECODE ( (SELECT COUNT (*)
                     FROM sz_accept
                    WHERE sz_id = h.sz_id AND accepted <> 0),
                 0, 1,
                 0)
            sz_not_seen
    FROM bonus_head h,
         bonus_body b,
         calendar c,
         bonus_types bt,
         bonus_types bst
   WHERE     h.id = b.bonus_id
         AND c.data = b.mz
         AND bt.id = h.bonus_type
         AND bst.id = h.bonus_subtype
         AND get_sz_current_status (h.sz_id) = 1
         AND (   (    :date_between = 'mz'
                  AND (b.mz BETWEEN TO_DATE ( :smz, 'dd.mm.yyyy')
                                AND TO_DATE ( :emz, 'dd.mm.yyyy')))
              OR (    :date_between = 'cr'
                  AND (TRUNC (get_sz_current_status_lu (h.sz_id)) BETWEEN TO_DATE (
                                                                             :scr,
                                                                             'dd.mm.yyyy')
                                                                      AND TO_DATE (
                                                                             :ecr,
                                                                             'dd.mm.yyyy'))))
         AND (   :exp_list_without_ts = 0
              OR NVL (b.tn, b.chief_tn) IN (SELECT slave
                                              FROM full
                                             WHERE master = :exp_list_without_ts))
         AND (   :exp_list_without_ts = 0
              OR NVL (b.tn, b.chief_tn) IN (SELECT slave
                                              FROM full
                                             WHERE master = :exp_list_only_ts))
         AND (   NVL (b.tn, b.chief_tn) IN (SELECT slave
                                              FROM full
                                             WHERE master = :tn)
              OR (SELECT is_traid
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_traid_kk
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_coach
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND h.dpt_id = :dpt_id
         AND ( :eta_list IS NULL OR :eta_list = b.h_eta)
         AND DECODE ( :region_name, '0', '0', :region_name) =
                DECODE ( :region_name, '0', '0', b.region)
         AND bst.id IN ( :bst)
ORDER BY b.mz, b.fio