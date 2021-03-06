/* Formatted on 29/01/2015 12:10:44 (QP5 v5.227.12220.39724) */
  SELECT SUM (bonus) bonus,
         SUM (cnt) cnt,
         fn_getname ( d.tn) fio_ts,
         COUNT (*) c1,
         d.tn
    FROM act_files d, user_list st
   WHERE     d.tn = st.tn
         AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND d.m = :month
         AND act = :act
GROUP BY d.tn
ORDER BY fio_ts