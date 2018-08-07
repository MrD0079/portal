/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1808rs.tab_num,
                 st.fio fio_ts,
                 a1808rs.fio_eta,
                 a1808rs.tp_ur,
                 a1808rs.tp_addr,
                 a1808rs.tp_kod,
                 DECODE (a1808rstps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1808rstps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1808rs.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1808rs_tp_select a1808rstps, a1808rs, user_list st
           WHERE     a1808rs.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1808rs.tp_kod = a1808rstps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1808rs.tab_num,
                 st.fio,
                 a1808rs.fio_eta,
                 a1808rs.tp_ur,
                 a1808rs.tp_addr,
                 a1808rs.tp_kod,
                 a1808rstps.contact_lpr,
                 DECODE (a1808rstps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1808rs.fio_eta, a1808rs.tp_ur)