/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1704f.tab_num,
                 st.fio fio_ts,
                 a1704f.fio_eta,
                 a1704f.tp_ur,
                 a1704f.tp_addr,
                 a1704f.tp_kod,
                 DECODE (a1704ftps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1704ftps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1704f.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1704f_tp_select a1704ftps, a1704f, user_list st
           WHERE     a1704f.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1704f.tp_kod = a1704ftps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1704f.tab_num,
                 st.fio,
                 a1704f.fio_eta,
                 a1704f.tp_ur,
                 a1704f.tp_addr,
                 a1704f.tp_kod,
                 a1704ftps.contact_lpr,
                 DECODE (a1704ftps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1704f.fio_eta, a1704f.tp_ur)