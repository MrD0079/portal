/* Formatted on 22.02.2013 10:02:47 (QP5 v5.163.1008.3004) */
  SELECT creamcherry.tab_num,
         st.fio fio_ts,
         creamcherry.fio_eta,
         creamcherry.tp_ur,
         creamcherry.tp_addr,
         creamcherry.tp_kod,
         creamcherrytps.selected,
         NVL (creamcherrytps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = creamcherry.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM creamcherry_tp_select creamcherrytps, creamcherry, user_list st
   WHERE     creamcherry.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND creamcherry.tp_kod = creamcherrytps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY creamcherry.tab_num,
         st.fio,
         creamcherry.fio_eta,
         creamcherry.tp_ur,
         creamcherry.tp_addr,
         creamcherry.tp_kod,
         creamcherrytps.selected,
         creamcherrytps.contact_lpr
ORDER BY st.fio, creamcherry.fio_eta, creamcherry.tp_ur