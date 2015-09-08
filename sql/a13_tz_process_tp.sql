/* Formatted on 01.07.2013 12:57:09 (QP5 v5.227.12220.39724) */
  SELECT a13_tz.tab_num,
         st.fio fio_ts,
         a13_tz.fio_eta,
         a13_tz.tp_ur,
         a13_tz.tp_addr,
         a13_tz.tp_kod,
         a13_tztps.selected,
         NVL (a13_tztps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_tz.tp_kod AND ROWNUM = 1))
            contact_lpr,
         SUM (a13_tz.salesinmay) salesinmay
    FROM a13_tz_tp_select a13_tztps, a13_tz, user_list st
   WHERE     a13_tz.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_tz.tp_kod = a13_tztps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_tz.h_fio_eta, :eta_list) =
                a13_tz.h_fio_eta
         AND a13_tztps.selected = 1
/*AND a13_tz.data BETWEEN TO_DATE ('13.05.2013', 'dd.mm.yyyy') AND TO_DATE ('31.05.2013', 'dd.mm.yyyy')*/
GROUP BY a13_tz.tab_num,
         st.fio,
         a13_tz.fio_eta,
         a13_tz.tp_ur,
         a13_tz.tp_addr,
         a13_tz.tp_kod,
         a13_tztps.selected,
         a13_tztps.contact_lpr
ORDER BY st.fio,
         a13_tz.fio_eta,
         a13_tz.tp_ur,
         a13_tz.tp_addr