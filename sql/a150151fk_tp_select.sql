/* Formatted on 26/11/2014 17:27:16 (QP5 v5.227.12220.39724) */
  SELECT a150151fk.tab_num,
         st.fio fio_ts,
         a150151fk.fio_eta,
         a150151fk.tp_ur,
         a150151fk.tp_addr,
         a150151fk.tp_kod,
         DECODE (a150151fktps.tp_kod, NULL, NULL, 1) selected,
         NVL (a150151fktps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a150151fk.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a150151fk_tp_select a150151fktps, a150151fk, user_list st
   WHERE     a150151fk.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150151fk.tp_kod = a150151fktps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a150151fk.tab_num,
         st.fio,
         a150151fk.fio_eta,
         a150151fk.tp_ur,
         a150151fk.tp_addr,
         a150151fk.tp_kod,
         a150151fktps.contact_lpr,
         DECODE (a150151fktps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a150151fk.fio_eta, a150151fk.tp_ur