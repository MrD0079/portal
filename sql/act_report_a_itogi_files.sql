/* Formatted on 29/01/2015 12:12:15 (QP5 v5.227.12220.39724) */
SELECT SUM (cnt) cnt, SUM (bonus) bonus
  FROM act_files f, user_list st
 WHERE     f.tn = st.tn
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
       AND m = :month
       AND act = :act