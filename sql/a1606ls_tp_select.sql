/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1606ls.tab_num,
         st.fio fio_ts,
         a1606ls.fio_eta,
         a1606ls.tp_ur,
         a1606ls.tp_addr,
         a1606ls.tp_kod,
         DECODE (a1606lstps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1606lstps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1606ls.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1606ls_tp_select a1606lstps, a1606ls, user_list st
   WHERE     a1606ls.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1606ls.tp_kod = a1606lstps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1606ls.tab_num,
         st.fio,
         a1606ls.fio_eta,
         a1606ls.tp_ur,
         a1606ls.tp_addr,
         a1606ls.tp_kod,
         a1606lstps.contact_lpr,
         DECODE (a1606lstps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1606ls.fio_eta, a1606ls.tp_ur