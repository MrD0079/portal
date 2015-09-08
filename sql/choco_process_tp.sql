/* Formatted on 04.02.2013 15:26:45 (QP5 v5.163.1008.3004) */
  SELECT choco.tab_num,
         st.fio fio_ts,
         choco.fio_eta,
         choco.tp_ur,
         choco.tp_addr,
         choco.tp_kod,
         chocotps.selected,
         NVL (chocotps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = choco.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM choco_tp_select chocotps, choco_box choco, user_list st
   WHERE     choco.tab_num = st.tab_num
/*         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.tn = :tn
*/


         AND (st.tn IN (SELECT slave
                         FROM full
                        WHERE master = :tn)
OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)


         AND choco.tp_kod = chocotps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', choco.h_fio_eta, :eta_list) = choco.h_fio_eta
         AND chocotps.selected = 1
GROUP BY choco.tab_num,
         st.fio,
         choco.fio_eta,
         choco.tp_ur,
         choco.tp_addr,
         choco.tp_kod,
         chocotps.selected,
         chocotps.contact_lpr
ORDER BY st.fio,
         choco.fio_eta,
         choco.tp_ur,
         choco.tp_addr