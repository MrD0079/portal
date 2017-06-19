/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1702b.tab_num,
         st.fio fio_ts,
         a1702b.fio_eta,
         a1702b.tp_ur,
         a1702b.tp_addr,
         a1702b.tp_kod,
         a1702btps.contact_lpr
    FROM a1702b_tp_select a1702btps, a1702b, user_list st
   WHERE     a1702b.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1702b.tp_kod = a1702btps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1702b.h_fio_eta, :eta_list) =
                a1702b.h_fio_eta
GROUP BY a1702b.tab_num,
         st.fio,
         a1702b.fio_eta,
         a1702b.tp_ur,
         a1702b.tp_addr,
         a1702b.tp_kod,
         a1702btps.contact_lpr
ORDER BY st.fio,
         a1702b.fio_eta,
         a1702b.tp_ur,
         a1702b.tp_addr