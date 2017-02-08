/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1702ks.tab_num,
         st.fio fio_ts,
         a1702ks.fio_eta,
         a1702ks.tp_ur,
         a1702ks.tp_addr,
         a1702ks.tp_kod,
         DECODE (a1702kstps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1702kstps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1702ks.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1702ks_tp_select a1702kstps, a1702ks, user_list st
   WHERE     a1702ks.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1702ks.tp_kod = a1702kstps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1702ks.tab_num,
         st.fio,
         a1702ks.fio_eta,
         a1702ks.tp_ur,
         a1702ks.tp_addr,
         a1702ks.tp_kod,
         a1702kstps.contact_lpr,
         DECODE (a1702kstps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1702ks.fio_eta, a1702ks.tp_ur