/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1706sl.tab_num,
                 st.fio fio_ts,
                 a1706sl.fio_eta,
                 a1706sl.tp_ur,
                 a1706sl.tp_addr,
                 a1706sl.tp_kod,
                 DECODE (a1706sltps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1706sltps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1706sl.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1706sl_tp_select a1706sltps, a1706sl, user_list st
           WHERE     a1706sl.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1706sl.tp_kod = a1706sltps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1706sl.tab_num,
                 st.fio,
                 a1706sl.fio_eta,
                 a1706sl.tp_ur,
                 a1706sl.tp_addr,
                 a1706sl.tp_kod,
                 a1706sltps.contact_lpr,
                 DECODE (a1706sltps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1706sl.fio_eta, a1706sl.tp_ur)