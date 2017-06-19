/* Formatted on 16.11.2016 17:17:04 (QP5 v5.252.13127.32867) */
SELECT SUM (selected)
  FROM (  SELECT m.tab_num,
                 st.fio fio_ts,
                 m.eta fio_eta,
                 m.tp_ur,
                 m.tp_addr,
                 a16115p.tp_kod,
                 m.tp_kod_dm,
                 DECODE (a16115ptps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a16115ptps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a16115p.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a16115p_select a16115ptps,
                 a16115p,
                 user_list st,
                 a14mega m
           WHERE     m.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a16115p.tp_kod = a16115ptps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
                 AND a16115p.tp_kod = m.tp_kod
                 AND m.dt = TO_DATE ('01/11/2016', 'dd/mm/yyyy')
        GROUP BY m.tab_num,
                 st.fio,
                 m.eta,
                 m.tp_ur,
                 m.tp_addr,
                 a16115p.tp_kod,
                 m.tp_kod_dm,
                 a16115ptps.contact_lpr,
                 DECODE (a16115ptps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, m.eta, m.tp_ur)