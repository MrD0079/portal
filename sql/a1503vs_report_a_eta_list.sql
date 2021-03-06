/* Formatted on 06/11/2014 11:32:20 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM a1503vs a, a1503vs_tp_select t, user_list st
   WHERE     a.TP_KOD = t.TP_KOD
         AND a.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id and st.is_spd=1
ORDER BY a.fio_eta