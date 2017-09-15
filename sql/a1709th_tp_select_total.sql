/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1709th.tab_num,
                 st.fio fio_ts,
                 a1709th.fio_eta,
                 a1709th.tp_ur,
                 a1709th.tp_addr,
                 a1709th.tp_kod,
                 DECODE (a1709thtps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1709thtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1709th.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1709th_tp_select a1709thtps, a1709th, user_list st
           WHERE     a1709th.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1709th.tp_kod = a1709thtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1709th.tab_num,
                 st.fio,
                 a1709th.fio_eta,
                 a1709th.tp_ur,
                 a1709th.tp_addr,
                 a1709th.tp_kod,
                 a1709thtps.contact_lpr,
                 DECODE (a1709thtps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1709th.fio_eta, a1709th.tp_ur)