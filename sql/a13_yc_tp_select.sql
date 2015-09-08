/* Formatted on 17.09.2013 16:28:36 (QP5 v5.227.12220.39724) */
  SELECT a13_yc.tab_num,
         st.fio fio_ts,
         a13_yc.fio_eta,
         a13_yc.tp_ur,
         a13_yc.tp_addr,
         a13_yc.tp_kod,
         a13_yctps.selected,
         NVL (a13_yctps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_yc.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_yc_tp_select a13_yctps, a13_yc, user_list st
   WHERE     a13_yc.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_yc.tp_kod = a13_yctps.tp_kod(+)
         AND st.dpt_id = :dpt_id
/*AND a13_yc.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
GROUP BY a13_yc.tab_num,
         st.fio,
         a13_yc.fio_eta,
         a13_yc.tp_ur,
         a13_yc.tp_addr,
         a13_yc.tp_kod,
         a13_yctps.selected,
         a13_yctps.contact_lpr
ORDER BY st.fio, a13_yc.fio_eta, a13_yc.tp_ur