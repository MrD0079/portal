/* Formatted on 29/01/2015 12:10:52 (QP5 v5.227.12220.39724) */
SELECT SUM (bonus) bonus, SUM (cnt) cnt
  FROM act_files d, user_list st
 WHERE     d.tn = st.tn
       AND st.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_without_ts,
                                 0, master,
                                 :exp_list_without_ts))
       AND st.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_only_ts,
                                 0, master,
                                 :exp_list_only_ts))
       AND (   st.tn IN (SELECT slave
                           FROM full
                          WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id
         AND d.m = :month
         AND act = :act
