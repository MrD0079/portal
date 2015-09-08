/* Formatted on 06.11.2014 15:05:50 (QP5 v5.227.12220.39724) */
  SELECT a14xs.tab_num,
         st.fio fio_ts,
         a14xs.fio_eta,
         a14xs.tp_ur,
         a14xs.tp_addr,
         a14xs.tp_kod,
         DECODE (a14xstps.tp_kod, NULL, NULL, 1) selected,
         NVL (a14xstps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a14xs.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a14xs_tp_select a14xstps, a14xs, user_list st
   WHERE     a14xs.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a14xs.tp_kod = a14xstps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND TO_NUMBER (TO_CHAR (a14xs.data, 'mm')) = :month
         AND a14xstps.m(+) = :month
GROUP BY a14xs.tab_num,
         st.fio,
         a14xs.fio_eta,
         a14xs.tp_ur,
         a14xs.tp_addr,
         a14xs.tp_kod,
         a14xstps.contact_lpr,
         DECODE (a14xstps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a14xs.fio_eta, a14xs.tp_ur