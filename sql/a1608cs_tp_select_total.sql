/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1608cs.tab_num,
                 st.fio fio_ts,
                 a1608cs.fio_eta,
                 a1608cs.tp_ur,
                 a1608cs.tp_addr,
                 a1608cs.tp_kod,
                 DECODE (a1608cstps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1608cstps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1608cs.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1608cs_tp_select a1608cstps, a1608cs, user_list st
           WHERE     a1608cs.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1608cs.tp_kod = a1608cstps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1608cs.tab_num,
                 st.fio,
                 a1608cs.fio_eta,
                 a1608cs.tp_ur,
                 a1608cs.tp_addr,
                 a1608cs.tp_kod,
                 a1608cstps.contact_lpr,
                 DECODE (a1608cstps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1608cs.fio_eta, a1608cs.tp_ur)