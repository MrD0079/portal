/* Formatted on 27.11.2013 14:11:53 (QP5 v5.227.12220.39724) */
  SELECT a13_sn.tab_num,
         st.fio fio_ts,
         a13_sn.fio_eta,
         a13_sn.tp_ur,
         a13_sn.tp_addr,
         a13_sn.tp_kod,
         a13_sntps.selected,
         NVL (a13_sntps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_sn.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_sn_tp_select a13_sntps, a13_sn, user_list st
   WHERE     a13_sn.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_sn.tp_kod = a13_sntps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_sn.h_fio_eta, :eta_list) =
                a13_sn.h_fio_eta
         AND a13_sntps.selected = 1
GROUP BY a13_sn.tab_num,
         st.fio,
         a13_sn.fio_eta,
         a13_sn.tp_ur,
         a13_sn.tp_addr,
         a13_sn.tp_kod,
         a13_sntps.selected,
         a13_sntps.contact_lpr
ORDER BY st.fio,
         a13_sn.fio_eta,
         a13_sn.tp_ur,
         a13_sn.tp_addr