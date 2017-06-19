/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1512nyp31.tab_num,
                 st.fio fio_ts,
                 a1512nyp31.fio_eta,
                 a1512nyp31.tp_ur,
                 a1512nyp31.tp_addr,
                 a1512nyp31.tp_kod,
                 DECODE (a1512nyp31tps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1512nyp31tps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1512nyp31.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1512nyp31_tp_select a1512nyp31tps, a1512nyp31, user_list st
           WHERE     a1512nyp31.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1512nyp31.tp_kod = a1512nyp31tps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1512nyp31.tab_num,
                 st.fio,
                 a1512nyp31.fio_eta,
                 a1512nyp31.tp_ur,
                 a1512nyp31.tp_addr,
                 a1512nyp31.tp_kod,
                 a1512nyp31tps.contact_lpr,
                 DECODE (a1512nyp31tps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1512nyp31.fio_eta, a1512nyp31.tp_ur)