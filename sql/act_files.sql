/* Formatted on 09/07/2015 17:29:55 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (d.lu, 'dd.mm.yyyy hh24:mi:ss') lu_text,
         d.*,
         fn_getname (d.tn) fio_ts,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM act_ok
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = d.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief
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
ORDER BY fio_ts, d.fn