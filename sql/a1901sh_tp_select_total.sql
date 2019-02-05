/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1901sh.tab_num,
                 st.fio fio_ts,
                 a1901sh.fio_eta,
                 a1901sh.tp_ur,
                 a1901sh.tp_addr,
                 a1901sh.tp_kod,
                 DECODE (a1901shtps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1901shtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1901sh.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1901sh_tp_select a1901shtps, a1901sh, user_list st
           WHERE     a1901sh.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1901sh.tp_kod = a1901shtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1901sh.tab_num,
                 st.fio,
                 a1901sh.fio_eta,
                 a1901sh.tp_ur,
                 a1901sh.tp_addr,
                 a1901sh.tp_kod,
                 a1901shtps.contact_lpr,
                 DECODE (a1901shtps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1901sh.fio_eta, a1901sh.tp_ur)