/* Formatted on 30.08.2013 9:56:03 (QP5 v5.227.12220.39724) */
  SELECT a13_sm8.tab_num,
         st.fio fio_ts,
         a13_sm8.fio_eta,
         a13_sm8.tp_ur,
         a13_sm8.tp_addr,
         a13_sm8.tp_kod,
         a13_sm8tps.selected,
         NVL (a13_sm8tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_sm8.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_sm8_tp_select a13_sm8tps, a13_sm8, user_list st
   WHERE     a13_sm8.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_sm8.tp_kod = a13_sm8tps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_sm8.h_fio_eta, :eta_list) =
                a13_sm8.h_fio_eta
         AND a13_sm8tps.selected = 1
/*         AND a13_sm8.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
GROUP BY a13_sm8.tab_num,
         st.fio,
         a13_sm8.fio_eta,
         a13_sm8.tp_ur,
         a13_sm8.tp_addr,
         a13_sm8.tp_kod,
         a13_sm8tps.selected,
         a13_sm8tps.contact_lpr
ORDER BY st.fio,
         a13_sm8.fio_eta,
         a13_sm8.tp_ur,
         a13_sm8.tp_addr