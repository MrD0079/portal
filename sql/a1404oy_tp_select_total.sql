/* Formatted on 24.01.2014 16:38:04 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1404oy.tab_num,
                 st.fio fio_ts,
                 a1404oy.fio_eta,
                 a1404oy.tp_ur,
                 a1404oy.tp_addr,
                 a1404oy.tp_kod,
                 DECODE (a1404oytps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1404oytps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1404oy.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1404oy_tp_select a1404oytps, a1404oy, user_list st
           WHERE     a1404oy.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1404oy.tp_kod = a1404oytps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1404oy.tab_num,
                 st.fio,
                 a1404oy.fio_eta,
                 a1404oy.tp_ur,
                 a1404oy.tp_addr,
                 a1404oy.tp_kod,
                 a1404oytps.contact_lpr,
                 DECODE (a1404oytps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1404oy.fio_eta, a1404oy.tp_ur)