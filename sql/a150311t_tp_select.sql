/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a150311t.tab_num,
         st.fio fio_ts,
         a150311t.fio_eta,
         a150311t.tp_ur,
         a150311t.tp_addr,
         a150311t.tp_kod,
         DECODE (a150311ttps.tp_kod, NULL, NULL, 1) selected,
         NVL (a150311ttps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a150311t.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a150311t_tp_select a150311ttps, a150311t, user_list st
   WHERE     a150311t.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150311t.tp_kod = a150311ttps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a150311t.tab_num,
         st.fio,
         a150311t.fio_eta,
         a150311t.tp_ur,
         a150311t.tp_addr,
         a150311t.tp_kod,
         a150311ttps.contact_lpr,
         DECODE (a150311ttps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a150311t.fio_eta, a150311t.tp_ur