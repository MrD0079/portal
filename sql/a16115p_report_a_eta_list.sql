/* Formatted on 16.11.2016 17:29:34 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT m.eta fio_eta, m.h_eta h_fio_eta
    FROM a16115p a,
         a16115p_select t,
         user_list st,
         a14mega m
   WHERE     a.TP_KOD = t.TP_KOD
         AND m.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND a.tp_kod = m.tp_kod
         AND m.dt = TO_DATE ('01/11/2016', 'dd/mm/yyyy')
ORDER BY m.eta