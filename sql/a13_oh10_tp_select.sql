/* Formatted on 17.09.2013 16:28:36 (QP5 v5.227.12220.39724) */
  SELECT a13_oh10.tab_num,
         st.fio fio_ts,
         a13_oh10.fio_eta,
         a13_oh10.tp_ur,
         a13_oh10.tp_addr,
         a13_oh10.tp_kod,
         a13_oh10tps.selected,
         NVL (a13_oh10tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_oh10.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_oh10_tp_select a13_oh10tps, a13_oh10, user_list st
   WHERE     a13_oh10.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_oh10.tp_kod = a13_oh10tps.tp_kod(+)
         AND st.dpt_id = :dpt_id
/*AND a13_oh10.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
GROUP BY a13_oh10.tab_num,
         st.fio,
         a13_oh10.fio_eta,
         a13_oh10.tp_ur,
         a13_oh10.tp_addr,
         a13_oh10.tp_kod,
         a13_oh10tps.selected,
         a13_oh10tps.contact_lpr
ORDER BY st.fio, a13_oh10.fio_eta, a13_oh10.tp_ur