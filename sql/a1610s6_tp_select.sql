/* Formatted on 18/04/2016 15:39:18 (QP5 v5.252.13127.32867) */
  SELECT m.tab_num,
         st.fio fio_ts,
         m.eta fio_eta,
         m.tp_ur,
         m.tp_addr,
         a1610s6.tp_kod,
         DECODE (a1610s6tps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1610s6tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1610s6.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1610s6_select a1610s6tps,
         a1610s6,
         user_list st,
         a14mega m
   WHERE     m.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1610s6.tp_kod = a1610s6tps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND a1610s6.tp_kod = m.tp_kod
         AND m.dt = to_date('01/10/2016','dd/mm/yyyy')
GROUP BY m.tab_num,
         st.fio,
         m.eta,
         m.tp_ur,
         m.tp_addr,
         a1610s6.tp_kod,
         a1610s6tps.contact_lpr,
         DECODE (a1610s6tps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, m.eta, m.tp_ur