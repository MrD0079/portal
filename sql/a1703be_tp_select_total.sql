/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1703be.tab_num,
                 st.fio fio_ts,
                 a1703be.fio_eta,
                 a1703be.tp_ur,
                 a1703be.tp_addr,
                 a1703be.tp_kod,
                 DECODE (a1703betps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1703betps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1703be.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1703be_tp_select a1703betps, a1703be, user_list st
           WHERE     a1703be.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1703be.tp_kod = a1703betps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1703be.tab_num,
                 st.fio,
                 a1703be.fio_eta,
                 a1703be.tp_ur,
                 a1703be.tp_addr,
                 a1703be.tp_kod,
                 a1703betps.contact_lpr,
                 DECODE (a1703betps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1703be.fio_eta, a1703be.tp_ur)