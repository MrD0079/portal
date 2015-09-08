/* Formatted on 03/06/2013 9:31:09 (QP5 v5.227.12220.39724) */
  SELECT a13_mavk.tab_num,
         st.fio fio_ts,
         a13_mavk.fio_eta,
         a13_mavk.tp_ur,
         a13_mavk.tp_addr,
         a13_mavk.tp_kod,
         a13_mavktps.selected,
         NVL (a13_mavktps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_mavk.tp_kod AND ROWNUM = 1))
            contact_lpr,
         a13_mavk.summa_aprel sales_aprel
    FROM a13_mavk_tp_select a13_mavktps, a13_mavk, user_list st
   WHERE     a13_mavk.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_mavk.tp_kod = a13_mavktps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_mavk.h_fio_eta, :eta_list) =
                a13_mavk.h_fio_eta
         AND a13_mavktps.selected = 1
GROUP BY a13_mavk.tab_num,
         st.fio,
         a13_mavk.fio_eta,
         a13_mavk.tp_ur,
         a13_mavk.tp_addr,
         a13_mavk.tp_kod,
         a13_mavktps.selected,
         a13_mavktps.contact_lpr,a13_mavk.summa_aprel
ORDER BY st.fio,
         a13_mavk.fio_eta,
         a13_mavk.tp_ur,
         a13_mavk.tp_addr