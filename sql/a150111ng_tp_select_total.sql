/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a150111ng.tab_num,
                 st.fio fio_ts,
                 a150111ng.fio_eta,
                 a150111ng.tp_ur,
                 a150111ng.tp_addr,
                 a150111ng.tp_kod,
                 DECODE (a150111ngtps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a150111ngtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a150111ng.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a150111ng_tp_select a150111ngtps, a150111ng, user_list st
           WHERE     a150111ng.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a150111ng.tp_kod = a150111ngtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a150111ng.tab_num,
                 st.fio,
                 a150111ng.fio_eta,
                 a150111ng.tp_ur,
                 a150111ng.tp_addr,
                 a150111ng.tp_kod,
                 a150111ngtps.contact_lpr,
                 DECODE (a150111ngtps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a150111ng.fio_eta, a150111ng.tp_ur)