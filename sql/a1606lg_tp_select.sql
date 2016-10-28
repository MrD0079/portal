/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1606lg.tab_num,
         st.fio fio_ts,
         a1606lg.fio_eta,
         a1606lg.tp_ur,
         a1606lg.tp_addr,
         a1606lg.tp_kod,
         DECODE (a1606lgtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1606lgtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1606lg.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1606lg_tp_select a1606lgtps, a1606lg, user_list st
   WHERE     a1606lg.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1606lg.tp_kod = a1606lgtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1606lg.tab_num,
         st.fio,
         a1606lg.fio_eta,
         a1606lg.tp_ur,
         a1606lg.tp_addr,
         a1606lg.tp_kod,
         a1606lgtps.contact_lpr,
         DECODE (a1606lgtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1606lg.fio_eta, a1606lg.tp_ur