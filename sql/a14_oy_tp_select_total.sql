/* Formatted on 24.01.2014 16:38:04 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a14_oy.tab_num,
                 st.fio fio_ts,
                 a14_oy.fio_eta,
                 a14_oy.tp_ur,
                 a14_oy.tp_addr,
                 a14_oy.tp_kod,
                 DECODE (a14_oytps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a14_oytps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a14_oy.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a14_oy_tp_select a14_oytps, a14_oy, user_list st
           WHERE     a14_oy.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a14_oy.tp_kod = a14_oytps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
                 AND TO_NUMBER (TO_CHAR (a14_oy.data, 'mm')) = :month
                 AND a14_oytps.m(+) = :month
        GROUP BY a14_oy.tab_num,
                 st.fio,
                 a14_oy.fio_eta,
                 a14_oy.tp_ur,
                 a14_oy.tp_addr,
                 a14_oy.tp_kod,
                 a14_oytps.contact_lpr,
                 DECODE (a14_oytps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a14_oy.fio_eta, a14_oy.tp_ur)