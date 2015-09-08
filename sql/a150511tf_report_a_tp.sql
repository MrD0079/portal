/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150511tf.tab_num,
         st.fio fio_ts,
         a150511tf.fio_eta,
         a150511tf.tp_ur,
         a150511tf.tp_addr,
         a150511tf.tp_kod,
         a150511tftps.contact_lpr
    FROM a150511tf_tp_select a150511tftps, a150511tf, user_list st
   WHERE     a150511tf.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150511tf.tp_kod = a150511tftps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a150511tf.h_fio_eta, :eta_list) =
                a150511tf.h_fio_eta
GROUP BY a150511tf.tab_num,
         st.fio,
         a150511tf.fio_eta,
         a150511tf.tp_ur,
         a150511tf.tp_addr,
         a150511tf.tp_kod,
         a150511tftps.contact_lpr
ORDER BY st.fio,
         a150511tf.fio_eta,
         a150511tf.tp_ur,
         a150511tf.tp_addr