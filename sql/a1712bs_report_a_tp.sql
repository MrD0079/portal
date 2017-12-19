/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1712bs.tab_num,
         st.fio fio_ts,
         a1712bs.fio_eta,
         a1712bs.tp_ur,
         a1712bs.tp_addr,
         a1712bs.tp_kod,
         a1712bstps.contact_lpr
    FROM a1712bs_tp_select a1712bstps, a1712bs, user_list st
   WHERE     a1712bs.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1712bs.tp_kod = a1712bstps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1712bs.h_fio_eta, :eta_list) =
                a1712bs.h_fio_eta
GROUP BY a1712bs.tab_num,
         st.fio,
         a1712bs.fio_eta,
         a1712bs.tp_ur,
         a1712bs.tp_addr,
         a1712bs.tp_kod,
         a1712bstps.contact_lpr
ORDER BY st.fio,
         a1712bs.fio_eta,
         a1712bs.tp_ur,
         a1712bs.tp_addr