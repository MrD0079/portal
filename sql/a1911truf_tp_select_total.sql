/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1911truf.tab_num,
                 st.fio fio_ts,
                 a1911truf.fio_eta,
                 a1911truf.tp_ur,
                 a1911truf.tp_addr,
                 a1911truf.tp_kod,
                 DECODE (a1911truftps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1911truftps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1911truf.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1911truf_tp_select a1911truftps, a1911truf, user_list st
           WHERE     a1911truf.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1911truf.tp_kod = a1911truftps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1911truf.tab_num,
                 st.fio,
                 a1911truf.fio_eta,
                 a1911truf.tp_ur,
                 a1911truf.tp_addr,
                 a1911truf.tp_kod,
                 a1911truftps.contact_lpr,
                 DECODE (a1911truftps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1911truf.fio_eta, a1911truf.tp_ur)