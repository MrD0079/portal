/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1803bo.tab_num,
         st.fio fio_ts,
         a1803bo.fio_eta,
         a1803bo.tp_ur,
         a1803bo.tp_addr,
         a1803bo.tp_kod,
         a1803botps.contact_lpr
    FROM a1803bo_tp_select a1803botps, a1803bo, user_list st
   WHERE     a1803bo.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1803bo.tp_kod = a1803botps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1803bo.h_fio_eta, :eta_list) =
                a1803bo.h_fio_eta
GROUP BY a1803bo.tab_num,
         st.fio,
         a1803bo.fio_eta,
         a1803bo.tp_ur,
         a1803bo.tp_addr,
         a1803bo.tp_kod,
         a1803botps.contact_lpr
ORDER BY st.fio,
         a1803bo.fio_eta,
         a1803bo.tp_ur,
         a1803bo.tp_addr