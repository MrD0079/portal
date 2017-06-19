/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a150511tf.tab_num,
         st.fio fio_ts,
         a150511tf.fio_eta,
         a150511tf.tp_ur,
         a150511tf.tp_addr,
         a150511tf.tp_kod,
         DECODE (a150511tftps.tp_kod, NULL, NULL, 1) selected,
         NVL (a150511tftps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a150511tf.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a150511tf_tp_select a150511tftps, a150511tf, user_list st
   WHERE     a150511tf.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150511tf.tp_kod = a150511tftps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a150511tf.tab_num,
         st.fio,
         a150511tf.fio_eta,
         a150511tf.tp_ur,
         a150511tf.tp_addr,
         a150511tf.tp_kod,
         a150511tftps.contact_lpr,
         DECODE (a150511tftps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a150511tf.fio_eta, a150511tf.tp_ur