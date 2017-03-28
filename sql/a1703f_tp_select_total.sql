/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1703f.tab_num,
                 st.fio fio_ts,
                 a1703f.fio_eta,
                 a1703f.tp_ur,
                 a1703f.tp_addr,
                 a1703f.tp_kod,
                 DECODE (a1703ftps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1703ftps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1703f.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1703f_tp_select a1703ftps, a1703f, user_list st
           WHERE     a1703f.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1703f.tp_kod = a1703ftps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1703f.tab_num,
                 st.fio,
                 a1703f.fio_eta,
                 a1703f.tp_ur,
                 a1703f.tp_addr,
                 a1703f.tp_kod,
                 a1703ftps.contact_lpr,
                 DECODE (a1703ftps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1703f.fio_eta, a1703f.tp_ur)