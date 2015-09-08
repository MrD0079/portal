/* Formatted on 19.01.2015 18:15:47 (QP5 v5.227.12220.39724) */
  SELECT f.*, u.fio
    FROM user_list u, akcii_local_files f
   WHERE     f.z_id = :z_id
         AND f.tn = u.tn
         AND u.dpt_id = :dpt_id
         /*AND u.datauvol IS NULL*/
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, master,
                                   :exp_list_only_ts))
         AND (u.tn IN (SELECT slave
                         FROM full
                        WHERE master = :tn))
ORDER BY u.fio, f.fn