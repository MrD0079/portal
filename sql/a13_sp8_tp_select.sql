/* Formatted on 26.07.2013 12:13:52 (QP5 v5.227.12220.39724) */
  SELECT v.tab_num,
         st.fio fio_ts,
         v.fio_eta,
         v.tp_ur,
         v.tp_addr,
         v.tp_kod,
         vtps.selected,
         NVL (vtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = v.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_sp8_tp_select vtps, a13_sp8 v, user_list st /*,
                                             (SELECT *
                                                FROM val_vesna_tp_select
                                               WHERE m = 3 and selected = 1) cc*/
   WHERE     v.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND v.tp_kod = vtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         /*AND v.tp_kod = cc.tp_kod(+)
         AND cc.tp_kod IS NULL*/
         AND (nvl(v.s1_1,0) = 0 OR nvl(v.s1_2,0) = 0 OR nvl(v.s1_3,0) = 0)
GROUP BY v.tab_num,
         st.fio,
         v.fio_eta,
         v.tp_ur,
         v.tp_addr,
         v.tp_kod,
         vtps.selected,
         vtps.contact_lpr
ORDER BY fio_ts, fio_eta, tp_ur