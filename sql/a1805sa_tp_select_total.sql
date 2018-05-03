/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1805sa.tab_num,
                 st.fio fio_ts,
                 a1805sa.fio_eta,
                 a1805sa.tp_ur,
                 a1805sa.tp_addr,
                 a1805sa.tp_kod,
                 DECODE (a1805satps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1805satps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1805sa.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1805sa_tp_select a1805satps, a1805sa, user_list st
           WHERE     a1805sa.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1805sa.tp_kod = a1805satps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1805sa.tab_num,
                 st.fio,
                 a1805sa.fio_eta,
                 a1805sa.tp_ur,
                 a1805sa.tp_addr,
                 a1805sa.tp_kod,
                 a1805satps.contact_lpr,
                 DECODE (a1805satps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1805sa.fio_eta, a1805sa.tp_ur)