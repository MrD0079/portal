/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1604sh.tab_num,
                 st.fio fio_ts,
                 a1604sh.fio_eta,
                 a1604sh.tp_ur,
                 a1604sh.tp_addr,
                 a1604sh.tp_kod,
                 DECODE (a1604shtps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1604shtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1604sh.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1604sh_tp_select a1604shtps, a1604sh, user_list st
           WHERE     a1604sh.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1604sh.tp_kod = a1604shtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1604sh.tab_num,
                 st.fio,
                 a1604sh.fio_eta,
                 a1604sh.tp_ur,
                 a1604sh.tp_addr,
                 a1604sh.tp_kod,
                 a1604shtps.contact_lpr,
                 DECODE (a1604shtps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1604sh.fio_eta, a1604sh.tp_ur)