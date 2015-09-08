/* Formatted on 06.11.2014 15:05:50 (QP5 v5.227.12220.39724) */
  SELECT a14ny.tab_num,
         st.fio fio_ts,
         a14ny.fio_eta,
         a14ny.tp_ur,
         a14ny.tp_addr,
         a14ny.tp_kod,
         DECODE (a14nytps.tp_kod, NULL, NULL, 1) selected,
         NVL (a14nytps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a14ny.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a14ny_tp_select a14nytps, a14ny, user_list st
   WHERE     a14ny.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a14ny.tp_kod = a14nytps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND TO_NUMBER (TO_CHAR (a14ny.data, 'mm')) = :month
         AND a14nytps.m(+) = :month
GROUP BY a14ny.tab_num,
         st.fio,
         a14ny.fio_eta,
         a14ny.tp_ur,
         a14ny.tp_addr,
         a14ny.tp_kod,
         a14nytps.contact_lpr,
         DECODE (a14nytps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a14ny.fio_eta, a14ny.tp_ur