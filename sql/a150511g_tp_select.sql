/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a150511g.tab_num,
         st.fio fio_ts,
         a150511g.fio_eta,
         a150511g.tp_ur,
         a150511g.tp_addr,
         a150511g.tp_kod,
         DECODE (a150511gtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a150511gtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a150511g.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a150511g_tp_select a150511gtps, a150511g, user_list st
   WHERE     a150511g.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150511g.tp_kod = a150511gtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a150511g.tab_num,
         st.fio,
         a150511g.fio_eta,
         a150511g.tp_ur,
         a150511g.tp_addr,
         a150511g.tp_kod,
         a150511gtps.contact_lpr,
         DECODE (a150511gtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a150511g.fio_eta, a150511g.tp_ur